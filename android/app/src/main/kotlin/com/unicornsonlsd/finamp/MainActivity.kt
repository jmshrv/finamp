package com.unicornsonlsd.finamp

import androidx.annotation.NonNull
import androidx.mediarouter.app.SystemOutputSwitcherDialogController
import androidx.mediarouter.media.MediaRouter
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: AudioServiceActivity() {
  private val CHANNEL = "com.unicornsonlsd.finamp/output_switcher"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      println("calling method: '${call.method}'")
      if (call.method == "showOutputSwitcherDialog") {
        showOutputSwitcherDialog()
        result.success(null)
      } else if (call.method == "getRoutes") {
        val router = MediaRouter.getInstance(this)
        val routes = router.routes
        routes.forEach { route ->
          println("Route: ${route.name}, connection state: ${route.connectionState}, system route: ${route.isSystemRoute}, default: ${route.isDefault}, device speaker: ${route.isDeviceSpeaker}, bluetooth: ${route.isBluetooth}, volume: ${route.volume}, provider: ${route.provider.packageName}")
        }
      } else if (call.method == "setOutputToDeviceSpeaker") {
        val router = MediaRouter.getInstance(this)
        val routes = router.getRoutes()
        routes.forEach { route ->
          println("Route: ${route.name}, connection state: ${route.connectionState}, system route: ${route.isSystemRoute}, default: ${route.isDefault}, device speaker: ${route.isDeviceSpeaker}, bluetooth: ${route.isBluetooth}, volume: ${route.volume}, provider: ${route.provider.packageName}")
        }
        val deviceSpeakerRoute = routes.first { route -> route.isDeviceSpeaker }
        router.selectRoute(deviceSpeakerRoute)
      } else if (call.method == "setOutputToBluetoothDevice") {
        val router = MediaRouter.getInstance(this)
        val routes = router.getRoutes()
        routes.forEach { route ->
          println("Route: ${route.name}, connection state: ${route.connectionState}, system route: ${route.isSystemRoute}, default: ${route.isDefault}, device speaker: ${route.isDeviceSpeaker}, bluetooth: ${route.isBluetooth}, volume: ${route.volume}, provider: ${route.provider.packageName}")
        }
        val bluetoothRoute = routes.first { route -> route.isBluetooth }
        router.selectRoute(bluetoothRoute)
      }
      else {
        println("Method not found: '${call.method}'")
        result.notImplemented()
      }
    }
  }

  private fun showOutputSwitcherDialog() {
    SystemOutputSwitcherDialogController.showDialog(this)
  }
}
