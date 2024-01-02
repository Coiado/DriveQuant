//
//  AppDelegate.swift
//  DriveQuantTest
//
//  Created by Lucas Coiado Mota on 12/22/23.
//

import UIKit
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import DriveKitCommonUI
import DriveKitPermissionsUtilsUI
import SpeedCalculator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DriveKit.shared.initialize(delegate: self)
        DriveKitTripAnalysis.shared.initialize(tripListener: self, appLaunchOptions: launchOptions)
        DriveKitUI.shared.initialize()
        DriveKitPermissionsUtilsUI.shared.initialize()
        DriveKit.shared.setApiKey(key: "2eqyqDNXOnBpkIDAPo9eNqxh")
        DriveKit.shared.setUserId(userId: "1911b3c1-79b5-4787-97b5-f0d04270ddf8")
        print("Configure esta certo:")
        print(DriveKit.shared.isConfigured())
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: DriveKitDelegate {
    func driveKitDidConnect(_ driveKit: DriveKit) {
        // Connected to DriveKit.
    }

    func driveKit(_ driveKit: DriveKit, didReceiveAuthenticationError error: RequestError) {
        // DriveKit authentication error: \(error).
    }

    func driveKitDidDisconnect(_ driveKit: DriveKit) {
        // Disconnected from DriveKit.
    }

    func userIdUpdateStatusChanged(status: UpdateUserIdStatus, userId: String?) {
        // DriveKit userId updated: userId = \(userId), status = \(status).
    }
    
    func driveKit(_ driveKit: DriveKit, accountDeletionCompleted status: DeleteAccountStatus) {
         // account deletion completed with status \(status).
    }
}

extension AppDelegate: TripListener {
    func tripStarted(startMode: DriveKitTripAnalysisModule.StartMode) {
    }
    
    func tripFinished(post: DriveKitTripAnalysisModule.PostGeneric, response: DriveKitTripAnalysisModule.PostGenericResponse) {
        
    }
    
    func tripCancelled(cancelTrip: DriveKitTripAnalysisModule.CancelTrip) {
        
    }
    
    func tripSavedForRepost() {
        
    }
}

