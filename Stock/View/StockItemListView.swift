//
//  StockItemListView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct StockItemListView: View {
    
    @ObservedObject private var rootViewModel = RootViewModel.shared
    
    public let stock: Stock
    
    @State var name = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                HeaderView(leadingIcon: "chevron.backward",
                           trailingIcon: "plus.square",
                           leadingAction: { dismiss() },
                           trailingAction: {
                    withAnimation() {
                        // 明示的なアニメーション指定
                        if rootViewModel.currentMode != .add {
                            rootViewModel.onAddMode()
                        } else {
                            rootViewModel.offSortMode()
                        }
                    }
                })
                
                if rootViewModel.currentStock.items.isEmpty || rootViewModel.currentMode == .add {
                    InputView(name: $name, action: {
                        rootViewModel.createStockItem(listId: rootViewModel.currentStock.id, name: name, order: rootViewModel.currentStock.size)
                    }).transition(.scale)
                }
                
                VStack {
                    Text(rootViewModel.currentStock.name)
                    
                    Rectangle()
                        .stroke(Color.green, lineWidth: 2)
                        .frame(width: 200, height: 2)
                }
                
                if rootViewModel.currentItems.isEmpty {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width)
                } else {
                    AvailableListBackGroundStack {
                        ForEach(rootViewModel.currentItems) { item in
                            
                            HStack{
                                if item.name.prefix(1) != "-" {
                                    Button {
                                        rootViewModel.updateFlagStockItem(itemId: item.id, flag: !item.flag)
                                    } label: {
                                        Image(systemName: item.flag ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(.green)

                                    }.buttonStyle(.plain)
                                }
                                
                                StockRowView(id: item.id , displayName: item.name ,stockItemFlag: true)
                            }
                            
                        }.onMove { sourceSet, destination in
                            rootViewModel.changeOrderStockItem(list: rootViewModel.currentStock, sourceSet: sourceSet, destination: destination)
                        }.onDelete { sourceSet in
                            rootViewModel.deleteStockItem(list: rootViewModel.currentStock, sourceSet: sourceSet, listId: rootViewModel.currentStock.id)
                        }.deleteDisabled(rootViewModel.currentMode != .delete)
                            .listRowBackground(Color.clear)
                    }.padding(.bottom, 20)
                }
            }
            // MARK: - Footer
            FooterView()
            
        }.environment(\.editMode, .constant(rootViewModel.editSortMode))
        .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hexString: "#434343"),Color(hexString: "#000000")]),
                    startPoint: .top, endPoint: .bottom
                ))
            .onAppear {
                if rootViewModel.currentStock.items.isEmpty {
                    rootViewModel.onAddMode()
                }
                rootViewModel.setCurrentStock(id: stock.id)
            }
    }
}


struct StockItemListView_Previews: PreviewProvider {
    static var previews: some View {
        StockItemListView(stock: Stock())
    }
}
