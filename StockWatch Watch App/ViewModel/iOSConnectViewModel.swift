//
//  iOSConnectViewModel.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/02.
//

import WatchConnectivity

class iOSConnectViewModel: NSObject, ObservableObject {
    
    static var shared = iOSConnectViewModel()
    
    private var repositoryViewModel = RepositoryViewModel.shared
    
    @Published var isConnenct: Bool = false

    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    public func sendCheckItemNotify(stockId: String, itemId: String, flag: Bool) {
        let toggle = flag == false
        let stockDic: [String: String] = ["CheckItemNotify": stockId + "," + itemId + "," + String(toggle)]
        self.session.sendMessage(stockDic) { error in
            print(error)
        }
    }
}


extension iOSConnectViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("セッション：アクティベート")
            isConnenct = true
        }
    }
    
    /// iOSアプリ通信可能状態が変化した際に呼ばれる
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async { [weak self] in
            print(session.isReachable)
            self?.isConnenct = session.isReachable
        }
    }
    
    /// sendMessageメソッドで送信されたデータを受け取るデリゲートメソッド
   func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
       print("iOSからデータを受け取ったよ")
       // iOSからデータを取得
       guard let json = message["stocks"] as? String else { return }
       print("iOSからデータを受け取ったよ")
       // JSONデータをString型→Data型に変換
       guard let jsonData = String(json).data(using: .utf8) else { return }

       // JSONデータを構造体に準拠した形式に変換
       if let stocks = try? JSONDecoder().decode([Stock].self, from: jsonData) {
           print(stocks)
           DispatchQueue.main.async { [weak self] in
               self?.repositoryViewModel.setAllStock(stocks: stocks)
           }
       }
   }
    
}
