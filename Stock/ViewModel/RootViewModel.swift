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
    public func setLimitCapacity(_ capacity: Int) {
        userDefaultsManager.setLimitCapacity(capacity)
    }
    
    public func getLimitCapacity() -> Int {
        return userDefaultsManager.getLimitCapacity()
    }
    
    public func setCountInterstitial(_ count: Int) {
        userDefaultsManager.setCountInterstitial(count)
    }
    
    public func getCountInterstitial() -> Int {
        return userDefaultsManager.getCountInterstitial()
    }
    
    
}
