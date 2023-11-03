//
//  ContentView.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/02.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var iosConnector = iOSConnectViewModel()
    @State var isConnect: Bool = false
    
    var body: some View {
        VStack {
            Text(isConnect ? "connect" : "No connect")
            Button {
                print(iosConnector.session.isReachable)
                isConnect = iosConnector.session.isReachable
            } label: {
                Text("Check")
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
