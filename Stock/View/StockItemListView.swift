//
//  StockItemListView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct StockItemListView: View {
    private let viewModel = StockItemListViewModel()
    
    let list:Stock
    @State var name = ""
    
    @State var itemNames:[String] = [""]
    
    @State var addMode = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            HeaderView(leadingIcon: "chevron.backward", trailingIcon: "plus.square", leadingAction: {dismiss()}, trailingAction: {
                withAnimation() {          // 明示的なアニメーション指定
                    self.addMode.toggle()
                }
            })
            
            if list.items.isEmpty || addMode {
                InputView(name: $name, action: {
                    viewModel.createStockItem(listId: list.id, name: name, order: list.size)
                    
                    itemNames.append("")
                }).transition(.scale)
            }

            Text(list.name)
            if list.items.isEmpty {
                Spacer()
                    .frame(width: UIScreen.main.bounds.width)
            } else {
                AvailableListBackGroundStack {
                    ForEach(list.items.sorted(byKeyPath: "order")){ item in
                        HStack{
                            Button {
                                viewModel.updateFlagStockItem(itemId: item.id, flag: !item.flag)
                            } label: {
                                Image(systemName: item.flag ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.green)
                                
                            }.buttonStyle(.plain)
                            Text(item.name)
                            //                        TextField(item.name, text: $itemNames[item.order])
                            //                            .onChange(of: itemNames[item.order]) { newValue in
                            //                                    viewModel.updateStockItem(itemId: item.id, name: newValue)
                            //                            }
                            
                        }
                        .swipeActions(edge: .leading) {
                            Button(role: .destructive) {
                                viewModel.deleteStockItem(listId: list.id, itemId: item.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }.onMove { sourceSet, destination in
                        viewModel.changeOrder(list: list, sourceSet: sourceSet, destination: destination)
                        itemNames.removeAll()
                        for item in list.items.sorted(byKeyPath: "order") {
                            itemNames.append(item.name)
                        }
                    }.listRowBackground(Color.clear)
                }
                .environment(\.editMode, .constant(EditMode.active))
                .onAppear {
                    itemNames.removeAll()
                    for item in list.items.sorted(byKeyPath: "order") {
                        itemNames.append(item.name)
                    }
                }
            }
        }.navigationBarBackButtonHidden()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hexString: "#434343"),Color(hexString: "#000000")]),
                    startPoint: .top, endPoint: .bottom
                ))
            .onAppear {
                if list.items.isEmpty {
                    addMode = true
                }
            }
    }
}


struct StockItemListView_Previews: PreviewProvider {
    static var previews: some View {
        StockItemListView(list: Stock.demoList)
    }
}
