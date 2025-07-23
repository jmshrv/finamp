import app_links
import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Exclude the documents and support folders from iCloud backup since we keep songs there.
        try! setExcludeFromiCloudBackup(
            try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true),
            isExcluded: true
        )
        
        try! setExcludeFromiCloudBackup(
            try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true),
            isExcluded: true
        )
        
        // Retrieve the link from parameters
        if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
            // We have a link, propagate it to your Flutter app or not
            AppLinks.shared.handleLink(url: url)
            return true  // Returning true will stop the propagation to other packages
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

private func setExcludeFromiCloudBackup(_ dir: URL, isExcluded: Bool) throws {
//    Awkwardly make a mutable copy of the dir
    var mutableDir = dir
    
    var values = URLResourceValues()
    values.isExcludedFromBackup = isExcluded
    try mutableDir.setResourceValues(values)
}
