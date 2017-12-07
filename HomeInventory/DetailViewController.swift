//
//  DetailViewController.swift
//  HomeInventory
//
//  Created by Carlos Poles on 2/12/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- Class Properties
    
    @IBOutlet var nameField: DetailTextField!
    
    @IBOutlet var serialNumberField: DetailTextField!
    
    @IBOutlet var valueField: DetailTextField!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Action Methods
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        // If the device has a camera, take a picture; otherwise, just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deletePicture(_ sender: UIBarButtonItem) {
        
        // Prompt user for deletion
        let title = "Delete picture?"
        let message = "Are you sure you want to delete this picture?"
        
        // create the AlertController
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        // create Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete",
                                         style: .destructive,
                                         handler: { (action) -> Void in
                                            
                                            // Remove item from itemStore
                                            self.imageStore.deleteImage(forKey: self.item.itemKey)
                                            self.imageView.image = nil
                                            
        })
        ac.addAction(deleteAction)
        
        // Present the alert controller
        present(ac, animated: true, completion: nil)
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    
    // MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Get the item key
        let key = item.itemKey
        
        // if there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear First Responder
        view.endEditing(true)
        
        // "Save changes to item"
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
                item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegation
    // TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismiss keyboard when user taps Return
        return textField.resignFirstResponder()
    }
    
    // ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // get picked image from info dictionary
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Put the image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen
        // call the dismiss method
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "changeDate"?:
            if let dateChangeViewController = segue.destination as? DateChangeViewController {
                dateChangeViewController.item = item
            } else {
                print("cast failed")
            }
            
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
