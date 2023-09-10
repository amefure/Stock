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
    
    private let grids = Array(repeating: GridItem(.fixed(90)), count: 3)
    var body: some View {
        VStack{
            HStack {
                TextField("", text: $name)
                Button {
                    if name.isEmpty { return }
                    viewModel.createStock(name: name, order: allBringList.count)
                } label: {
                    Image(systemName: "plus")
                }
            }.padding()
                .frame(width: UIScreen.main.bounds.width / 1.2)
                .background(Color(hexString: "#FFFFFF", alpha: 0.2))
                .cornerRadius(20)
            
            ScrollView() {
                LazyVGrid(columns: grids) {
                    ForEach(allBringList) { list in
                        NavigationLink {
                            StockItemListView(list: list)
                        } label: {
                            StockRowView(list: list)
                        }.foregroundColor(.cyan)
                    }
                }
            }
            
            HStack{
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "plus.bubble.fill")
                        .foregroundColor(.white)
                }
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "plus.rectangle.on.folder.fill")
                        .foregroundColor(.white)
                }
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "gear")
                        .foregroundColor(.white)
                }
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                }
                Spacer()
            }.frame(width: UIScreen.main.bounds.width / 2)
                .padding()
                .background(Color(hexString: "#222222"))
                .cornerRadius(40)
                .shadow(color: .gray,radius: 3, x: 1, y: 1)
        }
    }
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView()
    }
}
