//
//  FooterView.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import SwiftUI

struct FooterView: View {
    
    public var sortAction: () -> Void
    public var editAction: () -> Void
    public var trashAction: () -> Void
    
    var body: some View {
        HStack{
            Spacer()
            Button {
                sortAction()
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(.white)
            }
            Spacer()
            Button {
                editAction()
            } label: {
                Image(systemName: "pencil.tip.crop.circle")
                    .font(.title2)
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
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "gearshape")
                    .foregroundColor(.white)
            }
            Spacer()

        }.frame(width: UIScreen.main.bounds.width / 2)
            .padding()
            .background(Color(hexString: "#222222"))
            .cornerRadius(40)
            .shadow(color: .gray,radius: 3, x: 1, y: 1)
            .offset(y:UIScreen.main.bounds.height / 3)
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView(sortAction: {}, editAction: {}, trashAction: {})
    }
}
