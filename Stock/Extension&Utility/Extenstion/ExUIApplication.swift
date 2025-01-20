//
//  ExUIApplication.swift
//  Stock
//
//  Created by t&a on 2025/01/20.
//

import UIKit
import SwiftUI

extension UIApplication {
    // フォーカスの制御をリセット
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
