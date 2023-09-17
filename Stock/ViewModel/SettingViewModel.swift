//
//  SettingViewModel.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import UIKit

class SettingViewModel {
    
    private let appUrlStr = L10n.appUrl
    private let shareText = L10n.settingRecommendShareText

    // App Store URL
    private var appUrl: URL {
        if let encurl = appUrlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let url = URL(string: encurl) {
                return url
            }
        }
        return URL(string: "https://tech.amefure.com/")!
    }

    // App Store Review URL
    public var reviewUrl: URL {
        let reviewUrlString = appUrlStr + L10n.settingReviewUrlQuery
        if let encurl = reviewUrlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let url = URL(string: encurl) {
                return url
            }
        }
        return appUrl
    }

    // 利用規約&プライバシーポリシーURL
    public var termsUrl: URL {
        if let url =  URL(string: L10n.settingTermsOfServiceUrl) {
            return url
        }
        return appUrl
    }

    // アプリのシェアロジック
    public func shareApp() {
        let items = [shareText, appUrl] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popPC = activityVC.popoverPresentationController {
                popPC.sourceView = activityVC.view
                popPC.barButtonItem = .none
                popPC.sourceRect = activityVC.accessibilityFrame
            }
        }
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        rootVC?.present(activityVC, animated: true, completion: {})
    }
}
