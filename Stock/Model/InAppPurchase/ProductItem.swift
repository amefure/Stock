//
//  ProductItem.swift
//  Stock
//
//  Created by t&a on 2025/01/20.
//

enum ProductItem {
    case removeAds
    case unlockStorage

    public var id: String {
        return switch self {
        case .removeAds:
            #if DEBUG
                // テスト
                SecretProductIdKey.TEST_REMOVE_ADS
            #else
                // 本番
                SecretProductIdKey.REMOVE_ADS
            #endif
        case .unlockStorage:
            #if DEBUG
                // テスト
                SecretProductIdKey.TEST_UNLOCK_STORAGE
            #else
                // 本番
                SecretProductIdKey.UNLOCK_STORAGE
            #endif
        }
    }

    static func get(id: String) -> ProductItem? {
        switch id {
        case ProductItem.removeAds.id:
            return .removeAds
        case ProductItem.unlockStorage.id:
            return .unlockStorage
        default:
            return nil
        }
    }
}
