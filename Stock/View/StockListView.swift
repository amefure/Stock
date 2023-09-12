//
//  StockListView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI
import RealmSwift

struct StockListView: View {
    
    //    private var viewModel = StockListViewModel()
    
    @ObservedObject var rootViewModel = RootViewModel.shared
    @ObservedObject var interstitial = AdmobInterstitialView()
    
    @State private var name = ""
    
    @State private var isPresented = false
    
    @Environment(\.editMode) var editSortMode
    
    
    @State private var isLimitAlert: Bool = false // 上限に達した場合のアラート
    
    private func checkLimitCapacity() -> Bool {
        let limitCapacity = rootViewModel.getLimitCapacity()
        if rootViewModel.stocks.count >= limitCapacity {
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
                HeaderView(leadingIcon: "", trailingIcon: "", leadingAction: {}, trailingAction: {})
                
                InputView(name: $name, action: {
                    if checkLimitCapacity() {
                        rootViewModel.createStock(name: name, order: rootViewModel.stocks.count)
                    }
                })
                
                
                if rootViewModel.stocks.isEmpty {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width)
                } else {
                    
                    AvailableListBackGroundStack {
                        ForEach(rootViewModel.stocks) { stock in
                            
                        
                            if rootViewModel.currentMode == .delete {
                                StockRowView(id: stock.id, displayName: stock.name)
//                                Text(list.name)
                            } else {
                                //                                ZStack{
                                //                                    Button {
                                //                                        // 3回遷移したら広告を表示させる
                                //                                        var countInterstitial =  rootViewModel.getCountInterstitial()
                                //                                        countInterstitial += 1
                                //                                        if countInterstitial == 3 {
                                //                                            countInterstitial = 0
                                //                                            interstitial.presentInterstitial()
                                //                                        }
                                //                                        rootViewModel.setCountInterstitial(countInterstitial)
                                //                                        isPresented = true
                                //                                    } label: {
                                //                                        StockRowView(list: list, isDeleteMode: $isDeleteMode)
                                //                                    }
                                //                                    NavigationLink(value:list , label: { EmptyView() })
                                //                                }
                                NavigationLink {
                                    StockItemListView(stock: stock)
                                } label: {
                                    HStack {
                                        StockRowView(id: stock.id, displayName: stock.name)
                                    }
                                }
                            
                            }
                        }.onMove { sourceSet, destination in
                            rootViewModel.changeOrder(list: rootViewModel.stocks , sourceSet: sourceSet, destination: destination)
                        }.onDelete { sourceSet in
                            rootViewModel.deleteStock(list: rootViewModel.stocks , sourceSet: sourceSet)
                        }.deleteDisabled(rootViewModel.currentMode != .delete)
                            .listRowBackground(Color.clear)
                    }.padding(.bottom, 20)
                }
            }
            
            // MARK: - Footer
            FooterView(sortAction: {
                if editSortMode?.wrappedValue == .active {
                    editSortMode?.wrappedValue = .inactive
                } else {
                    editSortMode?.wrappedValue = .active
                }
            }, editAction: {
                
                rootViewModel.onEditNameMode()
                editSortMode?.wrappedValue = .inactive
                
            }, trashAction: {
                rootViewModel.onDeleteMode()
                editSortMode?.wrappedValue = .inactive
                
            })
            
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hexString: "#434343"),Color(hexString: "#000000")]),
                startPoint: .top, endPoint: .bottom
            ))
        .onAppear {
            rootViewModel.readAllStock()
            editSortMode?.wrappedValue = .inactive
            interstitial.loadInterstitial()
        }
        .alert(Text(L10n.dialogAdmobTitle),
               isPresented: $isLimitAlert,
               actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        }, message: {
            Text(L10n.dialogAdmobText)
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
