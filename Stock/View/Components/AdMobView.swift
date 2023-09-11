//
//  AdMobView.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import SwiftUI
import Foundation
import UIKit
import GoogleMobileAds


// MARK: - アプリID
// テスト  : ca-app-pub-3940256099942544~1458002511
// 本番  　:
// MARK: - バナー
// テスト  : ca-app-pub-3940256099942544/2934735716
// 本番  　:
// MARK: - リワード
// テスト  : ca-app-pub-3940256099942544/1712485313
// 本番  　:
// MARK: - インターステシャル
// テスト  : ca-app-pub-3940256099942544/4411468910
// 本番  　:

struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner) // インスタンスを生成
        // 諸々の設定をしていく
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 自身の広告IDに置き換える
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.rootViewController = windowScene?.windows.first!.rootViewController
        let request = GADRequest()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.load(request)
        return banner // 最終的にインスタンスを返す
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
      // 特にないのでメソッドだけ用意
    }
}


class Reward: NSObject, ObservableObject ,GADFullScreenContentDelegate {
    // リワード広告を読み込んだかどうか
    @Published  var rewardLoaded: Bool = false
    // リワード広告が格納される
    private var rewardedAd: GADRewardedAd? = nil
    
    override init() {
        super.init()
    }

    // リワード広告の読み込み
    public func loadReward() {
        let request = GADRequest()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request, completionHandler: { (ad, error) in
            if let _ = error {
                // 読み込みに失敗しました
                self.rewardLoaded = false
                return
            }
            // 読み込みに成功しました
            self.rewardLoaded = true
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        })
    }
    
    // 読み込んだリワード広告を表示するメソッド
    public func showReward() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        if let ad = rewardedAd {
            ad.present(fromRootViewController: rootVC!, userDidEarnRewardHandler: {
                // 報酬を獲得
                self.rewardLoaded = false
            })
        } else {
            self.rewardLoaded = false
            self.loadReward()
        }
    }
}

class AdmobInterstitialView: NSObject, ObservableObject, GADFullScreenContentDelegate {
    // インタースティシャル広告を読み込んだかどうか
    @Published var interstitialLoaded: Bool = false
    // インタースティシャル広告が格納される
    var interstitialAd: GADInterstitialAd?

    override init() {
        super.init()
    }

    // リワード広告の読み込み
    func loadInterstitial() {
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest()) { (ad, error) in
            if let _ = error {
                self.interstitialLoaded = false
                return
            }
            self.interstitialLoaded = true
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }

    // インタースティシャル広告の表示
    func presentInterstitial() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let root = windowScene?.windows.first!.rootViewController
        if let ad = interstitialAd {
            ad.present(fromRootViewController: root!)
            self.interstitialLoaded = false
        } else {
            self.interstitialLoaded = false
            self.loadInterstitial()
        }
    }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.loadInterstitial()
    }

}


