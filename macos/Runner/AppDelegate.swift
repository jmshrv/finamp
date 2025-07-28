import app_links
import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    override func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool {
        return true
    }

    public override func application(
        _ application: NSApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([any NSUserActivityRestoring]) -> Void
    ) -> Bool {
        guard let url = AppLinks.shared.getUniversalLink(userActivity) else {
            return false
        }

        AppLinks.shared.handleLink(link: url.absoluteString)

        return false  // Returning true will stop the propagation to other packages
    }
}
