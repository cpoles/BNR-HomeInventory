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
    var imageStore: ImageStore!

    // MARK: - Initialisation
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem // edit button property creates a UIBarButtonItem with the title Edit. 
                                                            // It also comes with a target-action pair: it calls setEditing(_:animated) in its
                                                            // ViewControler when tapped
    }
    
    // MARK:- Action Methods
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        // create new item and add to store
        let newItem = itemStore.createItem()
        
        // see where in the array the newItem is
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // insert new row to the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    // MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension // default value for row Height
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }


    // MARK:- TableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return the number of items in the itemStore"
        return itemStore.allItems.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell // cast cell to the ItemCell type
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == numberOfRows - 1 {
            cell.nameLabel?.text = "No more items."
            cell.valueLabel?.text = nil
            cell.serialNumberLabel?.text = nil
        } else {
            let item = itemStore.allItems[indexPath.row]
            cell.nameLabel?.text = item.name
            cell.serialNumberLabel?.text = item.serialNumber
            cell.valueLabel?.text = "$\(item.valueInDollars)"
            
            if item.valueInDollars > 50 {
                cell.valueLabel?.textColor = UIColor.green
            } else {
                cell.valueLabel?.textColor = UIColor.red
            }
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        // Do not allow the last row to be edited
        return indexPath.row == itemStore.allItems.count ? false : true
    }
    
    // Override to avoid the last row to be selected
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == itemStore.allItems.count ? false : true
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
                // Remove image from imageStore
                self.imageStore.deleteImage(forKey: item.itemKey)
                
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

        if indexPath.row == itemStore.allItems.count {
            boolRow = false
        }
        
        return boolRow
        
    }
    
    // Override to avoid rearranging after the last  row of the table view
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        var indexPath = IndexPath()
        
        if proposedDestinationIndexPath.row == itemStore.allItems.count {
            indexPath = sourceIndexPath
        } else {
            indexPath = proposedDestinationIndexPath
        }
        
        return indexPath
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            // figure out what row was tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                // Destination view controller
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    

}
