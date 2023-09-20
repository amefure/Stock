//
//  RewardButtonView.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import SwiftUI

struct RewardButtonView: View {

    // MARK: - AdMob
    @ObservedObject var reward = Reward()

    // MARK: - Storage
    @ObservedObject private var rootViewModel = RootViewModel.shared
    @AppStorage("LastAcquisitionDate") var lastAcquisitionDate = ""

    // MARK: - View
    @State var isAlertReward: Bool = false // リワード広告視聴回数制限アラート

    // MARK: - Method

    private func nowTime() -> String {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        df.dateStyle = .short
        df.timeStyle = .none
        return df.string(from: Date())
    }

    var body: some View {
        Button(action: {
            // 1日1回までしか視聴できないようにする
            if lastAcquisitionDate != nowTime() {
                reward.showReward() //  広告配信
                lastAcquisitionDate = nowTime() // 最終視聴日を格納
                // 広告視聴後に追加させるため時間をずらす
                DispatchQueue.main.asyncAfter ( deadline: DispatchTime.now() + 1) {
                    // 容量を追加
                    rootViewModel.addLimitCapacity()
                }
            } else {
                isAlertReward = true
            }
        }) {
            HStack {
                Image(systemName: "bag.badge.plus")
                    .foregroundColor(reward.rewardLoaded ? .white : .gray)
                Text(reward.rewardLoaded ? L10n.settingAdmobTitle : L10n.settingAdmobTitleDisable)
                    .foregroundColor(reward.rewardLoaded ? .white : .gray)
            }
        }
        .onAppear {
            reward.loadReward()
        }
        .disabled(!reward.rewardLoaded)
        .alert(Text(L10n.dialogAdmobTitle),
               isPresented: $isAlertReward,
               actions: {
                   Button(action: {}, label: {
                       Text("OK")
                   })
               }, message: {
                   Text(L10n.dialogAdmobText)
               })
    }
}

struct RewardButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RewardButtonView()
    }
}
