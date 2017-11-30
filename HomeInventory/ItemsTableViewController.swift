//
//  ItemsTableViewController.swift
//  HomeInventory
//
//  Created by Carlos Poles on 30/11/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    // MARK:- Stored Properties
    
    var itemStore: ItemsStore!

    
    // MARK:- Action Methods
    
    @IBAction func addNewItem(_ sender: UIButton) {
        print("New Item pressed.")
        
        // create new item and add to store
        let newItem = itemStore.createItem()
        
        // see where in the array the newItem is
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // insert new row to the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        print("Edit Mode pressed.")
        
        // If you are currently in editing mode
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            // turn off editing mode
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    
    // MARK:- App Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Avoid TableView cells to overlap the status bar
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }


    // MARK:- Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return the number of items in the itemStore"
        return itemStore.allItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let item = itemStore.allItems[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(item.valueInDollars)"
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        var boolRow: Bool = true
        
        // Do not reorder the last row of the tableView
        if indexPath.row == itemStore.allItems.count - 1 {
            boolRow = false
        }
        
        return boolRow
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // if the table view is asking to commit a delete command
        if editingStyle == .delete {
            
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            // create the AlertController
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            // create Cancel Action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .destructive,
                                             handler: { (action) -> Void in
            
                // Remove item from itemStore
                self.itemStore.removeItem(item)
                
                // Delete the row from the data source
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            })
            ac.addAction(deleteAction)
            
            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        // Update the model
        itemStore.moveItem(from: fromIndexPath.row, to: to.row)
        
    }
    
    // Override to change delete button text
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        
        var boolRow: Bool = true
        
        // Do not reorder the last row of the tableView
        if indexPath.row == itemStore.allItems.count - 1 {
            boolRow = false
        }
        
        return boolRow
        
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
