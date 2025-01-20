//
//  UserDefaultsRepository.swift
//  Stock
//
//  Created by t&a on 2025/01/20.
//

import UIKit

class UserDefaultsKey {
    /// 容量制限
    static let LIMIT_CAPACITY = "LimitCapacity"
    /// インタースティシャル表示カウント
    static let COUNT_INTERStITIAL = "CountInterstitial"
    /// アプリ内課金：広告削除
    static let PURCHASED_REMOVE_ADS = "PURCHASE_REMOVE_ADS"
    /// アプリ内課金：容量解放
    static let PURCHASED_UNLOCK_STORAGE = "PURCHASED_UNLOCK_STORAGE"


}

/// UserDefaultsの基底クラス
class UserDefaultsRepository {
    private let userDefaults = UserDefaults.standard

    /// Bool：保存
    public func setBoolData(key: String, isOn: Bool) {
        userDefaults.set(isOn, forKey: key)
    }

    /// Bool：取得
    public func getBoolData(key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }

    /// Int：保存
    public func setIntData(key: String, value: Int) {
        userDefaults.set(value, forKey: key)
    }

    /// Int：取得
    public func getIntData(key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }

    /// String：保存
    public func setStringData(key: String, value: String) {
        userDefaults.set(value, forKey: key)
    }

    /// String：取得
    public func getStringData(key: String, initialValue: String = "") -> String {
        return userDefaults.string(forKey: key) ?? initialValue
    }
}
