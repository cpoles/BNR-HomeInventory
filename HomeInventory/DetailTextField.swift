//
//  DetailTextField.swift
//  HomeInventory
//
//  Created by Carlos Poles on 3/12/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class DetailTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        borderStyle = .bezel
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        borderStyle = .roundedRect
        return true
    }
}
