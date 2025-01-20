//
//  InputView.swift
//  Stock
//
//  Created by t&a on 2023/09/11.
//

import SwiftUI

struct InputView: View {
    
    @Binding var name:String
    public var action: () -> Void
    
    var body: some View {
        HStack {
            TextField(L10n.textFieldPlaceholder, text: $name)
            Button {
                if name.isEmpty { return }
                action()
                name = ""
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            }
        }.padding()
            .frame(width: DeviceSizeUtility.deviceWidth / 1.2)
            .background(Color(hexString: "#222222"))
            .cornerRadius(20)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(name: Binding.constant("Stock"), action: {})
    }
}
