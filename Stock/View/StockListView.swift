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
    @State private var itemNames:[String] = [""]
    @State private var isPresented = false
    @State private var isEditNameMode = false
    @State private var isDeleteMode = false
    
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
                        rootViewModel.createStock(name: name, order: rootViewModel.stocks .count)
                    }
                })
                
                
                if rootViewModel.stocks .isEmpty {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width)
                } else {
                    
                    AvailableListBackGroundStack {
                        ForEach(rootViewModel.stocks ) { list in
                            
                            if isEditNameMode {
                                HStack {
                                    TextField(list.name, text: $itemNames[list.order])
                                        .padding(7.5)
                                        .onChange(of: itemNames[list.order]) { newValue in
                                            rootViewModel.updateStock(id: list.id, name: newValue)
                                        }
                                    Image(systemName: "pencil.tip.crop.circle")
                                        .foregroundColor(.gray)
                                }
                                
                            } else if editSortMode?.wrappedValue == .active || isDeleteMode {
                                
                                StockRowView(list: list, isDeleteMode: $isDeleteMode)
                                
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
                                    StockItemListView(stock: list)
                                } label: {
                                    StockRowView(list: list, isDeleteMode: $isDeleteMode)
                                }
                            }
                        }.onMove { sourceSet, destination in
                            rootViewModel.changeOrder(list: rootViewModel.stocks , sourceSet: sourceSet, destination: destination)
                        }.onDelete { sourceSet in
                            rootViewModel.deleteStock(list: rootViewModel.stocks , sourceSet: sourceSet)
                        }.deleteDisabled(!isDeleteMode)
                            .listRowBackground(Color.clear)
                    }.padding(.bottom, 20)
//                        .navigationDestination(for: Stock.self) { stock in
//                            StockItemListView()
//                        }
                }
            }
            
            // MARK: - Footer
            FooterView(sortAction: {
                if editSortMode?.wrappedValue == .active {
                    editSortMode?.wrappedValue = .inactive
                } else {
                    isDeleteMode = false
                    isEditNameMode = false
                    editSortMode?.wrappedValue = .active
                }
            }, editAction: {
                
                itemNames.removeAll()
                for item in rootViewModel.stocks {
                    itemNames.append(item.name)
                }
                if !isEditNameMode {
                    isDeleteMode = false
                    editSortMode?.wrappedValue = .inactive
                }
                isEditNameMode.toggle()
            }, trashAction: {
                if !isDeleteMode {
                    isEditNameMode = false
                    editSortMode?.wrappedValue = .inactive
                }
                isDeleteMode.toggle()
            })
            
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hexString: "#434343"),Color(hexString: "#000000")]),
                startPoint: .top, endPoint: .bottom
            ))
        .onAppear {
            rootViewModel.readAllStock()
            itemNames = Array(repeating: "", count: rootViewModel.stocks .count)
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
