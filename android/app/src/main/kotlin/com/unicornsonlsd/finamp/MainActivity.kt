package com.unicornsonlsd.finamp

import android.content.Intent
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
        result.success(routes.map { route ->
          mapOf(
            "name" to route.name,
            "connectionState" to route.connectionState,
            "isSystemRoute" to route.isSystemRoute,
            "isDefault" to route.isDefault,
            "isDeviceSpeaker" to route.isDeviceSpeaker,
            "isBluetooth" to route.isBluetooth,
            "volume" to route.volume,
            "providerPackageName" to route.provider.packageName,
            "isSelected" to route.isSelected(),
            "deviceType" to route.getDeviceType(),
            "description" to route.getDescription(),
            "extras" to route.getExtras(),
            "iconUri" to route.getIconUri(),
            // "controlFilters" to route.getControlFilters(),
          )
        })
      } else if (call.method == "setOutputToDeviceSpeaker") {
        val router = MediaRouter.getInstance(this)
        val routes = router.getRoutes()
        routes.forEach { route ->
          println("Route: ${route.name}, connection state: ${route.connectionState}, system route: ${route.isSystemRoute}, default: ${route.isDefault}, device speaker: ${route.isDeviceSpeaker}, bluetooth: ${route.isBluetooth}, volume: ${route.volume}, provider: ${route.provider.packageName}")
        }
        val deviceSpeakerRoute = routes.first { route -> route.isDeviceSpeaker }
        router.selectRoute(deviceSpeakerRoute)
        result.success(null)
      } else if (call.method == "setOutputToBluetoothDevice") {
        val router = MediaRouter.getInstance(this)
        val routes = router.getRoutes()
        routes.forEach { route ->
          println("Route: ${route.name}, connection state: ${route.connectionState}, system route: ${route.isSystemRoute}, default: ${route.isDefault}, device speaker: ${route.isDeviceSpeaker}, bluetooth: ${route.isBluetooth}, volume: ${route.volume}, provider: ${route.provider.packageName}")
        }
        val bluetoothRoute = routes.first { route -> route.isBluetooth }
        router.selectRoute(bluetoothRoute)
        result.success(null)
      } else if (call.method == "setOutputToRouteByName") {
        val router = MediaRouter.getInstance(this)
        val routes = router.getRoutes()
        routes.forEach { route ->
          println("Route: ${route.name}, connection state: ${route.connectionState}, system route: ${route.isSystemRoute}, default: ${route.isDefault}, device speaker: ${route.isDeviceSpeaker}, bluetooth: ${route.isBluetooth}, volume: ${route.volume}, provider: ${route.provider.packageName}")
        }
        val targetRoute = routes.first { route -> route.name == call.argument<String>("name") }
        router.selectRoute(targetRoute)
        result.success(null)
      } else if (call.method == "openBluetoothSettings") {
        startActivity(Intent(android.provider.Settings.ACTION_BLUETOOTH_SETTINGS))
        result.success(null)
      } else {
        println("Method not found: '${call.method}'")
        result.notImplemented()
      }
    }
  }

  private fun showOutputSwitcherDialog() {
    SystemOutputSwitcherDialogController.showDialog(this)
  }
}
