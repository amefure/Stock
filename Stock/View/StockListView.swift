//
//  StockListView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI
import RealmSwift

struct StockListView: View {
    
    private let viewModel = StockListViewModel()
    // MARK: - Database
    @ObservedResults(Stock.self) var allBringList
    
    @State private var name = ""
    @State var itemNames:[String] = [""]
    
    @State var isEditNameMode = false
    @State var isDeleteMode = false
    
    @Environment(\.editMode) var editSortMode
    
    var body: some View {
        ZStack {
            VStack{
                HeaderView(leadingIcon: "", trailingIcon: "", leadingAction: {}, trailingAction: {})
                
                InputView(name: $name, action: {
                    viewModel.createStock(name: name, order: allBringList.count)
                })
                
                
                if allBringList.isEmpty {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width)
                } else {
                    AvailableListBackGroundStack {
                        ForEach(allBringList.sorted(byKeyPath: "order")) { list in
                            
                            if isEditNameMode {
                                HStack {
                                    TextField(list.name, text: $itemNames[list.order])
                                        .padding(8)
                                        .onChange(of: itemNames[list.order]) { newValue in
                                            viewModel.updateStock(id: list.id, name: newValue)
                                        }
                                    Image(systemName: "pencil.and.outline")
                                        .foregroundColor(.gray)
                                }
                                
                            } else if editSortMode?.wrappedValue == .active || isDeleteMode {
                                
                                StockRowView(list: list, isDeleteMode: $isDeleteMode)
                                
                            } else {
                                NavigationLink {
                                    StockItemListView(list: list)
                                } label: {
                                    StockRowView(list: list, isDeleteMode: $isDeleteMode)
                                }
                            }
                        }.onMove { sourceSet, destination in
                            viewModel.changeOrder(list: allBringList, sourceSet: sourceSet, destination: destination)
                        }.onDelete { sourceSet in
                            viewModel.deleteStock(list: allBringList, sourceSet: sourceSet)
                        }.deleteDisabled(!isDeleteMode)
                            .listRowBackground(Color.clear)
                    }
                }
                AdMobBannerView().frame(height: 60)
            }
                
                FooterView(sortAction: {
                    if editSortMode?.wrappedValue == .active {
                        editSortMode?.wrappedValue = .inactive
                    } else {
                        isDeleteMode = false
                        isEditNameMode = false
                        editSortMode?.wrappedValue = .active
                    }
                },
                           editAction: {
                    
                    itemNames.removeAll()
                    for item in allBringList.sorted(byKeyPath: "order") {
                        itemNames.append(item.name)
                    }
                    if !isEditNameMode {
                        isDeleteMode = false
                        editSortMode?.wrappedValue = .inactive
                    }
                    isEditNameMode.toggle()
                },trashAction: {
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
            itemNames = Array(repeating: "", count: allBringList.count)
            editSortMode?.wrappedValue = .inactive
        }
    }
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView()
    }
}
