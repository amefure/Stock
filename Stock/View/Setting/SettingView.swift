//
//  SettingView.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import SwiftUI

struct SettingView: View {
    
    private let viewModel = SettingViewModel()
    
    @ObservedObject private var rootViewModel = RootViewModel.shared
    
    var body: some View {
        VStack{
            
            AvailableListBackGroundStack {
                Section(header: Text(L10n.settingCapacitySectionTitle), footer: Text(L10n.settingCapacitySectionFooter)) {
                    RewardButtonView()
                    HStack {
                        Image(systemName: "bag")
                        Text(L10n.settingCapacityText(rootViewModel.limitCapacity))
                    }
                    
                    // アプリ内課金
                    NavigationLink {
                        InAppPurchaseView()
                    } label: {
                        HStack {
                            Image(systemName: "app.gift.fill")
                            Text("広告削除 & 容量解放")
                        }.foregroundColor(.white)
                    }
                }
                
                // MARK: - (3)
                
                Section(header: Text("Link")) {
                    // 1:レビューページ
                    Link(destination: viewModel.reviewUrl, label: {
                        HStack {
                            Image(systemName: "hand.thumbsup")
                            Text(L10n.settingReviewTitle)
                        }.foregroundColor(.white)
                    })
                    
                    // 2:シェアボタン
                    Button(action: {
                        viewModel.shareApp()
                    }) {
                        HStack {
                            Image(systemName: "star.bubble")
                            Text(L10n.settingRecommendTitle)
                        }.foregroundColor(.white)
                    }
                    
                    // 3:利用規約とプライバシーポリシー
                    Link(destination: viewModel.termsUrl, label: {
                        HStack {
                            Image(systemName: "note.text")
                            Text(L10n.settingTermsOfServiceTitle)
                            Image(systemName: "link").font(.caption)
                        }.foregroundColor(.white)
                    })
                }
            }
            Spacer()
            
            AdMobBannerView()
                .frame(height: 60)

        }.gradientBackground()
            .toolbar {
                NavigationLink {
                    HowToUseTheAppView()
                } label: {
                    Image(systemName: "questionmark.app")
                }
            }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
