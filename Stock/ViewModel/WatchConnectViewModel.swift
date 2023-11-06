//
//  WatchConnectViewModel.swift
//  Stock
//
//  Created by t&a on 2023/11/02.
//

import UIKit
import Combine
import WatchConnectivity


class WatchConnectViewModel: NSObject, ObservableObject {
    
    static var shared = WatchConnectViewModel()
    
    @Published var isReachable = false
    
    private var session: WCSession
    
    override init() {
        self.session = .default
        super.init()
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    private func jsonConverter(stocks: [Stock]) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let jsonData = try? encoder.encode(stocks) {
            if let json = String(data: jsonData , encoding: .utf8) {
                // 文字コードUTF8のData型に変換
                return json
            }
        }
        // エンコード失敗
        return ""
    }
    
    public func send(stocks: [Stock]) {
        let json = jsonConverter(stocks: stocks)
        let stockDic: [String: String] = ["stocks": json]
        self.session.sendMessage(stockDic) { error in
            print(error)
        }
    }
}


extension WatchConnectViewModel: WCSessionDelegate {
    
    /// セッションのアクティベート状態が変化した際に呼ばれる
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Watch コネクトエラー" + error.localizedDescription)
        } else {
            isReachable = session.isReachable
        }
    }
    
    /// Watchアプリ通信可能状態が変化した際に呼ばれる
    func sessionReachabilityDidChange(_ session: WCSession) {
        isReachable = session.isReachable
    }

    func sessionDidBecomeInactive(_ session: WCSession) { }

    func sessionDidDeactivate(_ session: WCSession) { }
}
