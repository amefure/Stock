//
//  AvailableListBackGroundStack.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct AvailableListBackGroundStack<Content: View>: View {
    
    var content: () -> Content
    
    init(@ViewBuilder  content: @escaping () -> Content) {
        self.content = content
        UITableView.appearance().backgroundColor = UIColor.clear
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            List {
                self.content()
            }.listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        } else {
            List {
                self.content()
            }.listStyle(.grouped)
        }
    }
}

