//
//  FooterView.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import SwiftUI

struct FooterView: View {
    
    public var firstAction: () -> Void
    public var secondAction: () -> Void
    public var trashAction: () -> Void
    
    var body: some View {
        HStack{
            Spacer()
            Button {
                firstAction()
            } label: {
                Image(systemName: "plus.bubble.fill")
                    .foregroundColor(.white)
            }
            Spacer()
            Button {
                secondAction()
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
                trashAction()
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
            .offset(y:UIScreen.main.bounds.height / 2.5)
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView(firstAction: {}, secondAction: {}, trashAction: {})
    }
}
