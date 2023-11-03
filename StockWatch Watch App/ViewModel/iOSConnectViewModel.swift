//
//  iOSConnectViewModel.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/02.
//

import WatchConnectivity

class iOSConnectViewModel: NSObject, ObservableObject {
    
    @Published var stocks: [Stock] = []
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
}

extension iOSConnectViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("セッション：アクティベート")
        }
    }
    
    /// sendMessageメソッドで送信されたデータを受け取るデリゲートメソッド
   func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
       guard let lang = message["lang"] as? String else {
           return
       }
       isConnenct = true
   }
}
