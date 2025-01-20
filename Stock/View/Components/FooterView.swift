//
//  FooterView.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import SwiftUI

struct FooterView: View {
    
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    var body: some View {
        HStack{
            Spacer()
            Button {
                if rootEnvironment.currentMode != .sort {
                    rootEnvironment.onSortMode()
                } else {
                    rootEnvironment.offSortMode()
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(rootEnvironment.currentMode == .sort ? .green : .white)
            }
            Spacer()
            Button {
                if rootEnvironment.currentMode != .edit {
                    rootEnvironment.offSortMode()
                    rootEnvironment.onEditNameMode()
                } else {
                    rootEnvironment.offSortMode()
                }
            } label: {
                Image(systemName: "pencil.tip.crop.circle")
                    .font(.title2)
                    .foregroundColor(rootEnvironment.currentMode == .edit ? .green : .white)
            }
            Spacer()
            Button {
                if rootEnvironment.currentMode != .delete {
                    rootEnvironment.offSortMode()
                    rootEnvironment.onDeleteMode()
                } else {
                    rootEnvironment.offSortMode()
                }
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(rootEnvironment.currentMode == .delete ? .green : .white)
            }
            Spacer()
            NavigationLink {
                SettingView()
                    .environmentObject(rootEnvironment)
            } label: {
                Image(systemName: "gearshape")
                    .foregroundColor(rootEnvironment.currentMode == .sort ? .gray : .white)
            }.disabled(rootEnvironment.currentMode == .sort)
            Spacer()

        }.frame(width: DeviceSizeUtility.deviceWidth / 2)
            .padding()
            .background(Color(hexString: "#222222"))
            .cornerRadius(40)
            .shadow(color: .gray,radius: 3, x: 1, y: 1)
            .offset(y: DeviceSizeUtility.deviceHeight / 2.3)
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView()
            .environmentObject(RootEnvironment())
    }
}
