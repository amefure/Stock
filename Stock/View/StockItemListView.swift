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
    
    @State var isAddMode = false
    @State var isEditNameMode = false
    @State var isDeleteMode = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editSortMode
    
    func toggleEditSortMode() {
        if editSortMode?.wrappedValue == .active {
            editSortMode?.wrappedValue = .inactive
        } else {
            editSortMode?.wrappedValue = .active
        }
    }
    
    var body: some View {
        ZStack {
            
            VStack{
                HeaderView(leadingIcon: "chevron.backward", trailingIcon: "plus.square", leadingAction: {dismiss()}, trailingAction: {
                    withAnimation() {          // 明示的なアニメーション指定
                        self.isAddMode.toggle()
                        editSortMode?.wrappedValue = .active
                        isDeleteMode = false
                    }
                })
                
                if list.items.isEmpty || isAddMode {
                    InputView(name: $name, action: {
                        viewModel.createStockItem(listId: list.id, name: name, order: list.size)
                        
                        itemNames.append("")
                    }).transition(.scale)
                }
      
                ZStack {
                    VStack {
                        Text(list.name)
                        
                        Rectangle()
                          .stroke(Color.green, lineWidth: 2)
                          .frame(width: 200, height: 2)
                    }
                    if isEditNameMode {
                        Text("MODE：Edit")
                            .font(.caption)
                            .padding(5)
                            .background(Color(hexString: "#F2A92E"))
                            .cornerRadius(10)
                            .offset(y:40)
                            .transition(.slide)
                    } else if isDeleteMode {
                        Text("MODE：Delete")
                            .font(.caption)
                            .padding(5)
                            .background(Color(hexString: "#C84311"))
                            .cornerRadius(10)
                            .offset(y:40)
                            .transition(.slide)
                    }
                }
                
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
                                
                                
                                if isEditNameMode {
                                    TextField(item.name, text: $itemNames[item.order])
                                        .onChange(of: itemNames[item.order]) { newValue in
                                            viewModel.updateStockItem(itemId: item.id, name: newValue)
                                        }
                                } else {
                                    Text(item.name)
                                }
                                Text("\(item.order)")
                                Spacer()
                                
                                if isDeleteMode {
                                    Group {
                                        Image(systemName: "trash")
                                        Image(systemName: "arrow.left")
                                        Image(systemName: "hand.tap")
                                    }.font(.caption)
                                }
                            }
                            
                        }.onMove { sourceSet, destination in
                            viewModel.changeOrder(list: list, sourceSet: sourceSet, destination: destination)
                        }.onDelete { sourceSet in
                            viewModel.deleteStockItem(list: list, sourceSet: sourceSet, listId: list.id, itemId: list.items[sourceSet.first!].id)
                        }.deleteDisabled(!isDeleteMode)
                            .listRowBackground(Color.clear)
                    }
                    
                }
            }
            FooterView(firstAction: {}, secondAction: {
                withAnimation() {
                    itemNames.removeAll()
                    for item in list.items.sorted(byKeyPath: "order") {
                        itemNames.append(item.name)
                    }
                    if isEditNameMode {
                        editSortMode?.wrappedValue = .active
                    } else {
                        isDeleteMode = false
                        editSortMode?.wrappedValue = .inactive
                    }
                    isEditNameMode.toggle()
                }
            },trashAction: {
                withAnimation() {
                    if isDeleteMode {
                        editSortMode?.wrappedValue = .active
                    } else {
                        isEditNameMode = false
                        editSortMode?.wrappedValue = .inactive
                    }
                    isDeleteMode.toggle()
                }
            })
        }.navigationBarBackButtonHidden()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hexString: "#434343"),Color(hexString: "#000000")]),
                    startPoint: .top, endPoint: .bottom
                ))
            .onAppear {
                itemNames = Array(repeating: "", count: list.items.count)
                print(itemNames)
                if list.items.isEmpty {
                    isAddMode = true
                }
                editSortMode?.wrappedValue = .active
            }
    }
}


struct StockItemListView_Previews: PreviewProvider {
    static var previews: some View {
        StockItemListView(list: Stock.demoList)
    }
}
