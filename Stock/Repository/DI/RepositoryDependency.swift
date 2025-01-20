//
//  RepositoryDependency.swift
//  Stock
//
//  Created by t&a on 2025/01/20.
//

/// `Repository` クラスのDIクラス
class RepositoryDependency {
    /// `Repository`
    public let realmRepository: RealmRepository
    public let userDefaultsRepository: UserDefaultsRepository
    public let inAppPurchaseRepository: InAppPurchaseRepository

    // シングルトンインスタンスをここで保持する
    private static let sharedRealmRepository = RealmRepository()
    private static let sharedUserDefaultsRepository = UserDefaultsRepository()
    private static let sharedInAppPurchaseRepository = InAppPurchaseRepository()

    init() {
        realmRepository = RepositoryDependency.sharedRealmRepository
        userDefaultsRepository = RepositoryDependency.sharedUserDefaultsRepository
        inAppPurchaseRepository = RepositoryDependency.sharedInAppPurchaseRepository
    }
}
