//
//  DetailTextField.swift
//  HomeInventory
//
//  Created by Carlos Poles on 3/12/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class DetailTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
