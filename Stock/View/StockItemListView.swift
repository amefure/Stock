//
//  StockItemListView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct StockItemListView: View {
    
    @ObservedObject var rootViewModel = RootViewModel.shared
    
//    private let viewModel = StockItemListViewModel()
    let stock: Stock
    
    @State var name = ""
    
    @State var itemNames:[String] = [""]
    
    @State var isAddMode = false
    @State var isEditNameMode = false
    @State var isDeleteMode = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editSortMode
    
    var body: some View {
        ZStack {
            VStack {
                HeaderView(leadingIcon: "chevron.backward",
                           trailingIcon: "plus.square",
                           leadingAction: { dismiss() },
                           trailingAction: {
                    withAnimation() {          // 明示的なアニメーション指定
                        self.isAddMode.toggle()
                        editSortMode?.wrappedValue = .active
                        isDeleteMode = false
                    }
                })
                
                if rootViewModel.currentStock.items.isEmpty || isAddMode {
                    InputView(name: $name, action: {
                        rootViewModel.createStockItem(listId: rootViewModel.currentStock.id, name: name, order: rootViewModel.currentStock.size)
                        
                        itemNames.append("")
                    }).transition(.scale)
                }
                
                VStack {
                    Text(rootViewModel.currentStock.name)
                    
                    Rectangle()
                        .stroke(Color.green, lineWidth: 2)
                        .frame(width: 200, height: 2)
                }
                
                if rootViewModel.currentStock.items.isEmpty {
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
                                
//                                if isEditNameMode {
//                                    HStack {
//                                        TextField(item.name, text: $itemNames[item.order])
//                                            .onChange(of: itemNames[item.order]) { newValue in
//                                                rootViewModel.updateStockItem(itemId: item.id, name: newValue)
//                                            }
//                                        Image(systemName: "pencil.tip.crop.circle")
//                                            .foregroundColor(.gray)
//                                    }
//                                } else {
//                                    if item.name.prefix(1) == "-" {
//                                        Text("■ \(String(item.name.dropFirst()))")
//                                            .fontWeight(.bold)
//                                    } else {
                                        Text(item.name)
////                                        Text(item.order)
//                                    }
//
//                                }
//
//                                Spacer()
//
//                                if isDeleteMode {
//                                    Group {
//                                        Image(systemName: "trash")
//                                        Image(systemName: "arrow.left")
//                                        Image(systemName: "hand.tap")
//                                    }.font(.caption)
//                                        .foregroundColor(.gray)
//                                }
                            }
                        }.onMove { sourceSet, destination in
                            rootViewModel.changeOrderStockItem(list: rootViewModel.currentStock, sourceSet: sourceSet, destination: destination)
                        }.onDelete { sourceSet in
                            rootViewModel.deleteStockItem(list: rootViewModel.currentStock, sourceSet: sourceSet, listId: rootViewModel.currentStock.id)
                            print(rootViewModel.currentStock)
                        }.deleteDisabled(!isDeleteMode)
                            .listRowBackground(Color.clear)
                    }.padding(.bottom, 20)
                }
            }
            FooterView(sortAction:{
                if editSortMode?.wrappedValue == .active {
                    editSortMode?.wrappedValue = .inactive
                } else {
                    isDeleteMode = false
                    isEditNameMode = false
                    editSortMode?.wrappedValue = .active
                }
            }, editAction: {
                itemNames.removeAll()
                for item in rootViewModel.currentItems {
                    itemNames.append(item.name)
                }
                if isEditNameMode {
                    editSortMode?.wrappedValue = .active
                } else {
                    isDeleteMode = false
                    editSortMode?.wrappedValue = .inactive
                }
                isEditNameMode.toggle()
            }, trashAction: {
                if isDeleteMode {
                    editSortMode?.wrappedValue = .active
                } else {
                    isEditNameMode = false
                    editSortMode?.wrappedValue = .inactive
                }
                isDeleteMode.toggle()
            })
        }.navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hexString: "#434343"),Color(hexString: "#000000")]),
                    startPoint: .top, endPoint: .bottom
                ))
            .onAppear {
                itemNames = Array(repeating: "", count: rootViewModel.currentItems.count)
                if rootViewModel.currentStock.items.isEmpty {
                    isAddMode = true
                }
                editSortMode?.wrappedValue = .active
                rootViewModel.setCurrentStock(id: stock.id)
            }
    }
}


struct StockItemListView_Previews: PreviewProvider {
    static var previews: some View {
        StockItemListView(stock: Stock())
    }
}
