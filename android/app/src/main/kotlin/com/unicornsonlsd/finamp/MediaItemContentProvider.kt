package com.unicornsonlsd.finamp

import android.content.ContentProvider
import android.content.ContentValues
import android.database.Cursor
import android.net.Uri
import android.os.ParcelFileDescriptor
import android.util.LruCache
import java.io.File
import java.io.FileOutputStream
import java.net.URL

class MediaItemContentProvider : ContentProvider() {

    private lateinit var memoryCache : LruCache<String, ByteArray>

    override fun openFile(uri: Uri, mode: String): ParcelFileDescriptor? {
        if (uri.encodedFragment != null) {
            // we store the original scheme://host in fragment since it should be unused
            val origin = Uri.parse(uri.encodedFragment)
            val fixedUri = uri.buildUpon().fragment(null).scheme(origin.scheme).encodedAuthority(origin.encodedAuthority).toString()

            // check if we already cached the image
            val bytes = memoryCache.get(fixedUri)
            if (bytes != null) {
                return openPipeHelper(uri, "application/octet-stream", null, bytes) {output, _, _, _, b ->
                    FileOutputStream(output.fileDescriptor).write(b)
                }
            }

            val response = URL(fixedUri).readBytes()
            memoryCache.put(fixedUri, response)
            return openPipeHelper(uri, "application/octet-stream", null, response) {output, _, _, _, b ->
                FileOutputStream(output.fileDescriptor).write(b)
            }
        }

        // this means it's a local image (downloaded or placeholder art)
        return ParcelFileDescriptor.open(File(uri.path!!), ParcelFileDescriptor.MODE_READ_ONLY)
    }

    override fun onCreate(): Boolean {
        // Get max available VM memory, exceeding this amount will throw an
        // OutOfMemory exception. Stored in kilobytes as LruCache takes an
        // int in its constructor.
        val maxMemory = (Runtime.getRuntime().maxMemory() / 1024).toInt()

        // Use 1/8th of the available memory for this memory cache.
        val cacheSize = maxMemory / 8
        memoryCache  = object : LruCache<String, ByteArray>(cacheSize) {

            override fun sizeOf(key: String, value: ByteArray): Int {
                // The cache size will be measured in kilobytes rather than
                // number of items.
                return value.size / 1024
            }
        }

        return true
    }

    override fun query(uri: Uri, projection: Array<out String>?, selection: String?, selectionArgs: Array<out String>?, sortOrder: String?): Cursor? {
        return null
    }

    override fun getType(uri: Uri): String? {
        return null
    }

    override fun insert(uri: Uri, values: ContentValues?): Uri? {
        return null
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?): Int {
        return 0
    }

    override fun update(uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<out String>?): Int {
        return 0
    }
}