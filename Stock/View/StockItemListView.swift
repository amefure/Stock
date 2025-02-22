//
//  StockItemListView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct StockItemListView: View {
    
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @ObservedObject private var repository = RepositoryViewModel.shared
    @ObservedObject private var watchConnector = WatchConnectViewModel.shared
    
    public let stock: Stock
    
    @State var name = ""
    
    @Environment(\.dismiss) var dismiss
    
    private var progressWidth: CGFloat {
        if repository.currentStock.checkItemsCnt != 0 || repository.currentStock.size != 0 {
            let calcCheckCnt = repository.currentStock.checkItemsCnt
            let calcAllCnt = repository.currentStock.size - repository.currentStock.exclusionItemsCnt
            let width = 200 * CGFloat(calcCheckCnt/calcAllCnt)
            return width
        } else {
            return 200
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HeaderView(
                    leadingIcon: "chevron.backward",
                    trailingIcon: "plus.square",
                    leadingAction: { dismiss() },
                    trailingAction: {
                        withAnimation() {
                            // 明示的なアニメーション指定
                            if rootEnvironment.currentMode != .add {
                                rootEnvironment.onAddMode()
                            } else {
                                rootEnvironment.offSortMode()
                            }
                        }
                    }
                )
                
                if rootEnvironment.currentMode == .add {
                    InputView(
                        name: $name,
                        action: {
                            repository.createStockItem(listId: repository.currentStock.id, name: name, order: Int(repository.currentStock.size))
                            watchConnector.send(stocks: repository.stocks)
                        }     
                    ).transition(.scale)
                }
                
                VStack {
                    Text(repository.currentStock.name)
                    
                    
                    HStack {
                        // チェックリセットボタン
                        if repository.currentStock.size != 0 {
                            Button {
                                repository.updateAllFlagStockItem(listId: repository.currentStock.id, flag: false)
                                watchConnector.send(stocks: repository.stocks)
                            } label: {
                                Image(systemName: "checklist.unchecked")
                            }
                        }
                        // プログレスバー
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 200, height: 2)
                            Rectangle()
                                .stroke(Color.green, lineWidth: 2)
                                .frame(width: progressWidth, height: 2)
                        }
                        // Allチェックボタン
                        if repository.currentStock.size != 0 {
                            Button {
                                repository.updateAllFlagStockItem(listId: repository.currentStock.id, flag: true)
                                watchConnector.send(stocks: repository.stocks)
                            } label: {
                                Image(systemName: "checklist.checked")
                            }
                        }
                    }
                }.padding()
                
                
                if repository.currentItems.isEmpty {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width)
                } else {
                    AvailableListBackGroundStack {
                        ForEach(repository.currentItems) { item in
                            
                            HStack{
                                if item.name.prefix(1) != "-" {
                                    Button {
                                        repository.updateFlagStockItem(listId: repository.currentStock.id, itemId: item.id, flag: !item.flag)
                                        watchConnector.send(stocks: repository.stocks)
                                    } label: {
                                        Image(systemName: item.flag ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(.green)
                                    }.buttonStyle(.plain)
                                }
                                
                                StockRowView(id: item.id , displayName: item.name ,stockItemFlag: true)
                                    .environmentObject(rootEnvironment)
                            }
                            
                        }.onMove { sourceSet, destination in
                            repository.changeOrderStockItem(list: repository.currentStock, sourceSet: sourceSet, destination: destination)
                            watchConnector.send(stocks: repository.stocks)
                        }.onDelete { sourceSet in
                            repository.deleteStockItem(list: repository.currentStock, sourceSet: sourceSet, listId: repository.currentStock.id)
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
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .gradientBackground()
            .onAppear {
                repository.setCurrentStock(id: stock.id)
                if repository.currentStock.items.isEmpty {
                    rootEnvironment.onAddMode()
                } else {
                    rootEnvironment.onSortMode()
                }
            }.onDisappear {
                rootEnvironment.offSortMode()
            }
    }
}


struct StockItemListView_Previews: PreviewProvider {
    static var previews: some View {
        StockItemListView(stock: Stock())
    }
}
