package com.unicornsonlsd.finamp

import android.content.Context
import com.nt4f04und.android_content_provider.AndroidContentProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return AndroidContentProvider.getFlutterEngineGroup(this)
                .createAndRunDefaultEngine(this)
    }
}
