//
//  RootViewModel.swift
//  Stock
//
//  Created by t&a on 2023/09/12.
//

import SwiftUI


class RootViewModel: ObservableObject {
    
    static let shared = RootViewModel()
    private let userDefaultsManager = UserDefaultsManager()
    
    @Published var currentMode:Mode = .none
    @Published var editSortMode:EditMode = .inactive
    // 広告表示カウント
    @Published var countInterstitial:Int = 0 // 初期値
    // 保存容量
    @Published var limitCapacity:Int = 6     // 初期値
    // 追加容量
    private let addCapacity:Int = 3          // 増加値
    
    
    
    // Mode
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
    
    // UserDefaults
    public func addLimitCapacity() {
        limitCapacity += addCapacity
        userDefaultsManager.setLimitCapacity(limitCapacity)
    }
    
    public func loadLimitCapacity() {
        limitCapacity = userDefaultsManager.getLimitCapacity()
    }
    
    public func addCountInterstitial() {
        countInterstitial += 1
        userDefaultsManager.setCountInterstitial(countInterstitial)
    }
    
    public func getCountInterstitial() {
        countInterstitial = userDefaultsManager.getCountInterstitial()
    }
}
