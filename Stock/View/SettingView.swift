//
//  SettingView.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import SwiftUI

struct SettingView: View {
    
    private func shareApp(shareText: String, shareLink: String) {
        let items = [shareText, URL(string: shareLink)!] as [Any]
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
    
    @AppStorage("LimitCapacity") var limitCapacity = 6 // 初期値
    
    var body: some View {
        AvailableListBackGroundStack {
            Section(header: Text("広告"), footer: Text("・追加される容量は3個です。\n・容量の追加は1日に1回までです。")) {
                RewardButtonView().foregroundColor(.white)
                HStack {
                    Image(systemName: "bag")
                    Text("現在の容量:\(limitCapacity)個")
                }
            }//.listRowBackground(Color.clear)
            
            // MARK: - (3)
            
            Section(header: Text("Link")) {
                // 1:レビューページ
                Link(destination: URL(string: "https://apps.apple.com/jp/app/%E3%81%BF%E3%82%93%E3%81%AA%E3%81%AE%E8%AA%95%E7%94%9F%E6%97%A5/id1673431227?action=write-review")!, label: {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                        Text("アプリをレビューする")
                    }.foregroundColor(.white)
                })
                
                // 2:シェアボタン
                Button(action: {
                    shareApp(shareText: "", shareLink: "https://apps.apple.com/jp/app/%E3%81%BF%E3%82%93%E3%81%AA%E3%81%AE%E8%AA%95%E7%94%9F%E6%97%A5/id1673431227")
                }) {
                    HStack {
                        Image(systemName: "star.bubble")
                        Text("「Stock」をオススメする")
                    }.foregroundColor(.white)
                }
                
                // 3:利用規約とプライバシーポリシー
                Link(destination: URL(string: "https://tech.amefure.com/app-terms-of-service")!, label: {
                    HStack {
                        Image(systemName: "note.text")
                        Text("利用規約とプライバシーポリシー")
                        Image(systemName: "link").font(.caption)
                    }.foregroundColor(.white)
                })
            }
            
        }.background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hexString: "#434343"),Color(hexString: "#000000")]),
                startPoint: .top, endPoint: .bottom
            ))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
