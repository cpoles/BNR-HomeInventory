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
    
    // MARK:- Class Methods
    
    @discardableResult func createItem() -> Item {
        
        let newItem = Item(random: true)
        allItems.append(newItem)
        allItems = allItems.sorted { $0.valueInDollars < $1.valueInDollars }
        
        return newItem
    }
    
    // A function that removes an item from allItems
    func removeItem(_ item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
            allItems = allItems.sorted { $0.valueInDollars < $1.valueInDollars }
        }
    }
    
    // A function that change the order of the items in allItems array
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        // remove item from array
        allItems.remove(at: fromIndex)
        
        // insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }

}

