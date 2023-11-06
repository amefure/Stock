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
    @ObservedObject private var rootViewModel = RootViewModel.shared
    @ObservedObject private var interstitial = AdmobInterstitialView()
    @ObservedObject private var watchConnector = WatchConnectViewModel.shared
    
    @State private var name = ""
    @State private var isLimitAlert = false // 上限に達した場合のアラート
    
    private func checkLimitCapacity() -> Bool {
        if repository.stocks.count >= rootViewModel.limitCapacity {
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
                    HeaderView(leadingIcon: "", trailingIcon: "applewatch.radiowaves.left.and.right", leadingAction: {}, trailingAction: {})
                } else {
                    HeaderView(leadingIcon: "", trailingIcon: "", leadingAction: {}, trailingAction: {})
                }
                
                Button {
                    watchConnector.send(stocks: repository.stocks)
                } label: {
                    Text("JSON")
                }


                InputView(name: $name, action: {
                    if checkLimitCapacity() {
                        repository.createStock(name: name, order: repository.stocks.count)
                    }
                })
                
                
                if repository.stocks.isEmpty {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width)
                } else {
                    
                    AvailableListBackGroundStack {
                        ForEach(repository.stocks) { stock in
                            ZStack{
                                Button {
                                    // 3回遷移したら広告を表示させる
                                    rootViewModel.addCountInterstitial()
                                    if rootViewModel.countInterstitial == 3 {
                                        rootViewModel.countInterstitial = 0
                                        interstitial.presentInterstitial()
                                    }
                                } label: {
                                    StockRowView(id: stock.id, displayName: stock.name)
                                }
                                NavigationLink {
                                    StockItemListView(stock: stock)
                                } label: {
                                    EmptyView()
                                }.opacity(rootViewModel.currentMode == .none ? 1 : 0)
                            }
                        }.onMove { sourceSet, destination in
                            repository.changeOrder(list: repository.stocks , sourceSet: sourceSet, destination: destination)
                        }.onDelete { sourceSet in
                            repository.deleteStock(list: repository.stocks , sourceSet: sourceSet)
                        }.deleteDisabled(rootViewModel.currentMode != .delete)
                            .listRowBackground(Color.clear)
                    }.padding(.bottom, 20)
                }
            }
            
            // MARK: - Footer
            FooterView()
            
        }.environment(\.editMode, .constant(rootViewModel.editSortMode))
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hexString: "#434343"),
                                                Color(hexString: "#000000")]),
                    startPoint: .top, endPoint: .bottom
                ))
            .onAppear {
                repository.readAllStock()
                interstitial.loadInterstitial()
                rootViewModel.offSortMode()
                rootViewModel.loadLimitCapacity()
            }
            .alert(Text(L10n.dialogCapacityOverTitle),
                   isPresented: $isLimitAlert,
                   actions: {
                Button(action: {}, label: {
                    Text("OK")
                })
            }, message: {
                Text(L10n.dialogCapacityOverText)
            })
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
    }
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView()
    }
}
