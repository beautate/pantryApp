//
//  AddItemViewController.swift
//  PantryApp
//
//  Created by Beau Tate on 4/8/25.
//

import UIKit

class AddItemViewController: UIViewController {
    
    var onSave: ((PantryItem) -> Void)?
    var selectedItem : PantryItem?
    var pantryItems: [PantryItem] = []
    
    //Add outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard
            let name = nameTextField.text, !name.isEmpty,
            let quantityText = quantityTextField.text, let quantity = Double(quantityText),
            let unit = unitTextField.text, !unit.isEmpty
        else {
            // Optional: Show an alert if any field is missing (validation)
            return
        }

        // Create the updated item
        let updatedItem = PantryItem(name: name, quantity: quantity, unit: unit)

        // Call the onSave closure to pass the updated item back to the main view
        onSave?(updatedItem)

        // Dismiss the current view controller and go back to the main screen
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If editing, pre-fill the text fields with the selected item's values
        if let selectedItem = selectedItem {
            nameTextField.text = selectedItem.name
            quantityTextField.text = String(selectedItem.quantity)
            unitTextField.text = selectedItem.unit
        }
    }
    }
    

