//
//  StockRowView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct StockRowView: View {
    let list:Stock
    var body: some View {
        HStack{
            Text("\(list.name)")
        }
            .padding()
            .cornerRadius(8)
            .frame(width:80,height: 80)
//            .background(Color(hexString: "#FFFFFF",alpha: 0.1))
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .fill(Color(hexString: "#FFFFFF",alpha: 0.4))
                    
            }
            
            
    }
}

struct StockRowView_Previews: PreviewProvider {
    static var previews: some View {
        StockRowView(list: Stock.demoList)
    }
}
