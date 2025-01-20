//
//  UserDefaultsManager.swift
//  Stock
//
//  Created by t&a on 2023/09/12.
//

import UIKit

class UserDefaultsManager {
    
    private let userDefaultsRepository: UserDefaultsRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
    }
    
    // デフォルト容量数
    private let defaultCapacity: Int = 6
    
    public func setLimitCapacity(_ capacity: Int) {
        userDefaultsRepository.setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: capacity)
    }
    
    public func getLimitCapacity() -> Int {
        let capacity = userDefaultsRepository.getIntData(key: UserDefaultsKey.LIMIT_CAPACITY)
        if capacity == 0 {
            return defaultCapacity
        } else {
            return capacity
        }
    }
    
    public func setCountInterstitial(_ count: Int) {
        userDefaultsRepository.setIntData(key: UserDefaultsKey.COUNT_INTERStITIAL, value: count)
    }
    
    public func getCountInterstitial() -> Int {
        userDefaultsRepository.getIntData(key: UserDefaultsKey.COUNT_INTERStITIAL)
    }
    
    
    /// `PURCHASED_REMOVE_ADS`
    /// 取得：アプリ内課金 / 広告削除
    public func getPurchasedRemoveAds() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS)
    }

    /// 登録：アプリ内課金 / 広告削除
    public func setPurchasedRemoveAds(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS, isOn: flag)
    }

    /// `PURCHASED_UNLOCK_STORAGE`
    /// 取得：アプリ内課金 / 容量解放
    public func getPurchasedUnlockStorage() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_STORAGE)
    }

    /// 登録：アプリ内課金 / 容量解放
    public func setPurchasedUnlockStorage(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_STORAGE, isOn: flag)
    }
    
}
