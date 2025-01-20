//
//  StockListView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI
import RealmSwift

struct StockListView: View {
    
    @ObservedObject private var repository = RepositoryViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    @ObservedObject private var interstitial = AdmobInterstitialView()
    @ObservedObject private var watchConnector = WatchConnectViewModel.shared
    
    @State private var name = ""
    @State private var isLimitAlert = false // 上限に達した場合のアラート
    
    private func checkLimitCapacity() -> Bool {
        // 容量解放済みなら常にtrue
        guard !rootEnvironment.unlockStorage else { return true }
        if repository.stocks.count >= rootEnvironment.limitCapacity {
            isLimitAlert = true
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        ZStack {
            VStack{
                // MARK: - Header
                if watchConnector.isReachable {
                    HeaderView(trailingIcon: "applewatch.radiowaves.left.and.right")
                } else {
                    HeaderView()
                }

                InputView(
                    name: $name,
                    action: {
                        if checkLimitCapacity() {
                            repository.createStock(name: name, order: repository.stocks.count)
                            watchConnector.send(stocks: repository.stocks)
                        }
                    }
                )
                
                if repository.stocks.isEmpty {
                    Spacer()
                        .frame(width: DeviceSizeUtility.deviceWidth)
                } else {
                    
                    AvailableListBackGroundStack {
                        ForEach(repository.stocks) { stock in
                            ZStack{
                                Button {
                                    /// 広告削除を購入済みならインタースティシャルをスキップ
                                    guard !rootEnvironment.removeAds else { return }
                                    // 3回遷移したら広告を表示させる
                                    rootEnvironment.addCountInterstitial()
                                    if rootEnvironment.countInterstitial == 3 {
                                        rootEnvironment.countInterstitial = 0
                                        interstitial.presentInterstitial()
                                    }
                                } label: {
                                    StockRowView(id: stock.id, displayName: stock.name)
                                        .environmentObject(rootEnvironment)
                                }
                                NavigationLink {
                                    StockItemListView(stock: stock)
                                        .environmentObject(rootEnvironment)
                                } label: {
                                    EmptyView()
                                }.opacity(rootEnvironment.currentMode == .none ? 1 : 0)
                            }
                        }.onMove { sourceSet, destination in
                            repository.changeOrder(list: repository.stocks , sourceSet: sourceSet, destination: destination)
                            watchConnector.send(stocks: repository.stocks)
                        }.onDelete { sourceSet in
                            repository.deleteStock(list: repository.stocks , sourceSet: sourceSet)
                            watchConnector.send(stocks: repository.stocks)
                        }.deleteDisabled(rootEnvironment.currentMode != .delete)
                            .listRowBackground(Color.clear)
                    }.padding(.bottom, 20)
                }
            }
            
            // MARK: - Footer
            FooterView()
                .environmentObject(rootEnvironment)
            
        }.environment(\.editMode, .constant(rootEnvironment.editSortMode))
            .gradientBackground()
            .onAppear {
                repository.readAllStock()
                interstitial.loadInterstitial()
                rootEnvironment.onAppear()
                if watchConnector.isReachable {
                    watchConnector.send(stocks: repository.stocks)
                }
            }.alert(
                isPresented: $isLimitAlert,
                title: L10n.dialogCapacityOverTitle,
                message: L10n.dialogCapacityOverText
            )
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
    }
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView()
    }
}
