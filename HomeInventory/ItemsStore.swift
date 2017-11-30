//
//  ItemsStore.swift
//  HomeInventory
//
//  Created by Carlos Poles on 30/11/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import Foundation


class ItemsStore {
    
    var allItems = [Item]()
    
    
    @discardableResult func createItem() -> Item {
        
        let newItem = Item(random: true)
        allItems.append(newItem)
        
        return newItem
    }
    
    
    init() {
        for _ in 0...7 {
            createItem()
        }
    }
    
}
