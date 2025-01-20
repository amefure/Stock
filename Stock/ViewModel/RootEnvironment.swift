//
//  RootEnvironment.swift
//  Stock
//
//  Created by t&a on 2023/09/12.
//

import SwiftUI
import Combine

class RootEnvironment: ObservableObject {
    
    static let shared = RootEnvironment()
    
    @Published var currentMode:Mode = .none
    @Published var editSortMode:EditMode = .inactive
    /// 広告表示カウント
    @Published var countInterstitial: Int = 0
    /// 保存容量
    @Published var limitCapacity:Int = 6
    /// 広告削除購入フラグ
    @Published var removeAds: Bool = false
    /// 容量解放購入フラグ
    @Published var unlockStorage: Bool = false
    /// 追加容量
    private let addCapacity:Int = 3
    /// `Combine`
    private var cancellables: Set<AnyCancellable> = []
    
    /// `Repository`
    private let inAppPurchaseRepository: InAppPurchaseRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        inAppPurchaseRepository = repositoryDependency.inAppPurchaseRepository

        // 購入済み課金アイテム観測
        inAppPurchaseRepository.purchasedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                // 購入済みアイテム配列が変化した際に購入済みかどうか確認
                let removeAds = inAppPurchaseRepository.isPurchased(ProductItem.removeAds.id)
                let unlockStorage = inAppPurchaseRepository.isPurchased(ProductItem.unlockStorage.id)
                // 両者trueなら更新
                if removeAds { self.removeAds = true }
                if unlockStorage { self.unlockStorage = true }
            }.store(in: &cancellables)
    }
    
    public func onAppear() {
        offSortMode()
        loadLimitCapacity()
    }
    
    // MARK: Mode
    public func onAddMode(){
        currentMode = .add
        editSortMode = .inactive
    }
    
    public func onEditNameMode(){
        currentMode = .edit
        editSortMode = .inactive
    }

    public func onDeleteMode(){
        currentMode = .delete
        editSortMode = .inactive
    }
    
    public func onSortMode(){
        currentMode = .sort
        editSortMode = .active
    }
    
    public func offSortMode(){
        currentMode = .none
        editSortMode = .inactive
    }
    
    // MARK: UserDefaults
    public func addLimitCapacity() {
        limitCapacity += addCapacity
        AppManager.sharedUserDefaultManager.setLimitCapacity(limitCapacity)
    }
    
    private func loadLimitCapacity() {
        limitCapacity = AppManager.sharedUserDefaultManager.getLimitCapacity()
    }
    
    public func addCountInterstitial() {
        countInterstitial += 1
        AppManager.sharedUserDefaultManager.setCountInterstitial(countInterstitial)
    }
    
    public func getCountInterstitial() {
        countInterstitial = AppManager.sharedUserDefaultManager.getCountInterstitial()
    }
    
    /// アプリ起動回数取得
    private func getPurchasedFlag() {
        removeAds = AppManager.sharedUserDefaultManager.getPurchasedRemoveAds()
        unlockStorage = AppManager.sharedUserDefaultManager.getPurchasedUnlockStorage()
    }
}
