//
//  UserDefaultsManager.swift
//  Stock
//
//  Created by t&a on 2023/09/12.
//

import UIKit

class UserDefaultsManager {
    
    private let userDefaults = UserDefaults.standard
    
    // デフォルト容量数
    private let defaultCapacity:Int = 6
    
    
    public func setLimitCapacity(_ capacity: Int) {
        userDefaults.set(capacity, forKey: "LimitCapacity")
    }
    
    public func getLimitCapacity() -> Int {
        let capacity = userDefaults.integer(forKey: "LimitCapacity")
        if capacity == 0 {
            return defaultCapacity
        }else{
            return capacity
        }
    }
    
    public func setCountInterstitial(_ count: Int) {
        userDefaults.set(count, forKey: "CountInterstitial")
    }
    
    public func getCountInterstitial() -> Int {
        return userDefaults.integer(forKey: "CountInterstitial")
    }
    
}
