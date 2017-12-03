//
//  ItemCell.swift
//  HomeInventory
//
//  Created by Carlos Poles on 1/12/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    // MARK:- Class Variables
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    
    // MARK:- Class Methods
    
    // This method get called on an object after it is loaded from an archive, in this case, the storyboard file
    // This is used to update the views after changing the size of the font in Settings > General.
    // It ensures that the the view is redraw with the updated font sizes
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
    }
}
