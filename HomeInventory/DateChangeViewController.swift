//
//  DateChangeViewController.swift
//  HomeInventory
//
//  Created by Carlos Poles on 3/12/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class DateChangeViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    // MARK: - Class Properties
    var item: Item!
    
    
    // MARK: - App LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       item.dateCreated = datePicker.date
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
