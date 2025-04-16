//
//  AddItemViewController.swift
//  PantryApp
//
//  Created by Beau Tate on 4/8/25.
//

import UIKit

class AddItemViewController: UIViewController {
    //MARK: - Outlets, actions, and attributes
    var onSave: ((PantryItem) -> Void)?
    var selectedItem : PantryItem?
    var pantryItems: [PantryItem] = []
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    
    //Action to register whether thte save button has been tapped if all fields populated
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard
            let name = nameTextField.text, !name.isEmpty,
            let quantityText = quantityTextField.text, let quantity = Double(quantityText),
            let unit = unitTextField.text, !unit.isEmpty
        else {
            return
        }

        // Create the updated item
        let updatedItem = PantryItem(name: name, quantity: quantity, unit: unit)

        // Call the onSave closure to pass the updated item back to the main view
        onSave?(updatedItem)

        // Dismiss the view and escape
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Carry over text information if editing an item
        if let selectedItem = selectedItem {
            nameTextField.text = selectedItem.name
            quantityTextField.text = String(selectedItem.quantity)
            unitTextField.text = selectedItem.unit
        }
    }
    }
    

