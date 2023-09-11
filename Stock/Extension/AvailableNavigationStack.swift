//
//  AvailableNavigationStack.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct AvailableNavigationStack<Content:View>:View{
    var content:Content
    
    init(@ViewBuilder content:()-> Content) {
        self.content = content()
    }
    
    var body: some View{
        if #available(iOS 16.0, *) {
            NavigationStack{
                content
            }.accentColor(Color.orange)
        }else{
            NavigationView {
                content
            }.accentColor(Color.orange)
        }
    }
}
