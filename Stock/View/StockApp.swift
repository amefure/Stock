//
//  StockApp.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Firebase
        FirebaseApp.configure()
        // Google AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
}


@main
struct StockApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AvailableNavigationStack {
                // EditModeを動作させるためにVStackが必要
                VStack {
                    StockListView()
                }
            }
        }
    }
}
