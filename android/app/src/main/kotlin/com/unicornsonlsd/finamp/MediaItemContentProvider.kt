package com.unicornsonlsd.finamp

import com.nt4f04und.android_content_provider.AndroidContentProvider

class MediaItemContentProvider : AndroidContentProvider() {
    override val authority: String = "com.unicornsonlsd.finamp.MediaItemContentProvider"
    override val entrypointName = "mediaItemContentProviderEntrypoint"
}