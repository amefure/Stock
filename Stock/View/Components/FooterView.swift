//
//  FooterView.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import SwiftUI

struct FooterView: View {
    
    @ObservedObject private var rootViewModel = RootViewModel.shared
    
    var body: some View {
        HStack{
            Spacer()
            Button {
                if rootViewModel.currentMode != .sort {
                    rootViewModel.onSortMode()
                } else {
                    rootViewModel.offSortMode()
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(rootViewModel.currentMode == .sort ? .green : .white)
            }
            Spacer()
            Button {
                if rootViewModel.currentMode != .edit {
                    rootViewModel.offSortMode()
                    rootViewModel.onEditNameMode()
                } else {
                    rootViewModel.offSortMode()
                }
            } label: {
                Image(systemName: "pencil.tip.crop.circle")
                    .font(.title2)
                    .foregroundColor(rootViewModel.currentMode == .edit ? .green : .white)
            }
            Spacer()
            Button {
                if rootViewModel.currentMode != .delete {
                    rootViewModel.offSortMode()
                    rootViewModel.onDeleteMode()
                } else {
                    rootViewModel.offSortMode()
                }
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(rootViewModel.currentMode == .delete ? .green : .white)
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
            .offset(y:UIScreen.main.bounds.height / 2.3)
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView()
    }
}
