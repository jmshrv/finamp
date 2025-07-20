package com.unicornsonlsd.finamp

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import androidx.mediarouter.app.SystemOutputSwitcherDialogController
import androidx.mediarouter.media.MediaRouter
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    companion object {
        private const val OUTPUT_SWITCHER_CHANNEL = "com.unicornsonlsd.finamp/output_switcher"
    }

    private lateinit var mediaRouter: MediaRouter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        mediaRouter = MediaRouter.getInstance(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            OUTPUT_SWITCHER_CHANNEL,
        ).setMethodCallHandler { call, result ->
            println("calling method: '${call.method}'")
            when (call.method) {
                "showOutputSwitcherDialog" -> {
                    showOutputSwitcherDialog()
                    result.success(null)
                }
                "getRoutes" -> {
                    val routes = mediaRouter.routes
                    routes.log()
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
                            "isSelected" to route.isSelected,
                            "deviceType" to route.deviceType,
                            "description" to route.description,
                            "extras" to route.extras,
                            "iconUri" to route.iconUri,
                            // "controlFilters" to route.controlFilters,
                        )
                    })
                }
                "setOutputToDeviceSpeaker" -> {
                    val routes = mediaRouter.routes
                    routes.log()
                    val deviceSpeakerRoute = routes.first { route -> route.isDeviceSpeaker }
                    mediaRouter.selectRoute(deviceSpeakerRoute)
                    result.success(null)
                }
                "setOutputToBluetoothDevice" -> {
                    val routes = mediaRouter.routes
                    routes.log()
                    val bluetoothRoute = routes.first { route -> route.isBluetooth }
                    mediaRouter.selectRoute(bluetoothRoute)
                    result.success(null)
                }
                "setOutputToRouteByName" -> {
                    val routes = mediaRouter.routes
                    routes.log()
                    val targetRoute = routes.first { route ->
                        route.name == call.argument<String>("name")
                    }
                    mediaRouter.selectRoute(targetRoute)
                    result.success(null)
                }
                "openBluetoothSettings" -> {
                    startActivity(Intent(Settings.ACTION_BLUETOOTH_SETTINGS))
                    result.success(null)
                }
                else -> {
                    println("Method not found: '${call.method}'")
                    result.notImplemented()
                }
            }
        }
    }

    private fun List<MediaRouter.RouteInfo>.log() {
        forEach { route ->
            println("Route: ${route.name}, connection state: ${route.connectionState}, system route: ${route.isSystemRoute}, default: ${route.isDefault}, device speaker: ${route.isDeviceSpeaker}, bluetooth: ${route.isBluetooth}, volume: ${route.volume}, provider: ${route.provider.packageName}")
        }
    }

    private fun showOutputSwitcherDialog() {
        SystemOutputSwitcherDialogController.showDialog(this)
    }
}
