//
//  ViewController.swift
//  PantryApp
//
//  Created by Beau Tate on 4/8/25.
//
import Foundation
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Outlet view tableview
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        // Instantiate the AddItemViewController from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addVC = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as? AddItemViewController {
            
            // Set the onSave closure to update the pantry and reload the table view
            addVC.onSave = { [weak self] (newItem: PantryItem) in
                self?.pantryItems.append(newItem)  // Add the new item to the list
                PantryItem.save(self?.pantryItems ?? [])  // Save the updated list to UserDefaults
                self?.tableView.reloadData()  // Reload the table view to show the new item
            }
            
            // Present the AddItemViewController
            self.present(addVC, animated: true, completion: nil)
        }
    }
    
    
    //Initialize empty array of PantryItem
    var pantryItems: [PantryItem] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set table view data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        //Load in current items using helper method from PantryItem extension
        pantryItems = PantryItem.load()
        print("Loaded pantry items: \(pantryItems)")
        
        // Add a test item if the array is empty (for testing purposes)
        if pantryItems.isEmpty {
            let testItem = PantryItem(name: "Flour", quantity: 2, unit: "cups")
            pantryItems.append(testItem)
            PantryItem.save(pantryItems)  // Save the item to UserDefaults
        }
        
    }
    
    //Calculate the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pantryItems.count
    }
    
    // Configure the appearance of each cell in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PantryCell", for: indexPath) as! PantryTableViewCell
        let item = pantryItems[indexPath.row]
        cell.nameLabel.text = item.name
        cell.quantityLabel.text = "\(item.quantity)"
        cell.unitLabel.text = item.unit
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = pantryItems[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addVC = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as? AddItemViewController {
            
            // Pass the selected item to AddItemViewController
            addVC.selectedItem = selectedItem  // This will be nil when adding a new item
            
            // Set the onSave closure to update the pantryItems array
            addVC.onSave = { [weak self] updatedItem in
                if let selectedItem = addVC.selectedItem {
                    // Editing an existing item
                    if let index = self?.pantryItems.firstIndex(where: { $0.name == selectedItem.name }) {
                        self?.pantryItems[index] = updatedItem  // Update the existing item in the array
                    }
                } else {
                    // Adding a new item
                    // Check if the item already exists (by name)
                    if !(self?.pantryItems.contains(where: { $0.name == updatedItem.name }) ?? false) {
                        self?.pantryItems.append(updatedItem)  // Add the new item to the list
                    } else {
                        // Optionally: Show an alert if the item already exists
                        let alert = UIAlertController(title: "Item Exists", message: "An item with this name already exists in the pantry.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
                PantryItem.save(self?.pantryItems ?? [])  // Save the updated list to UserDefaults
                self?.tableView.reloadData()  // Reload the table view to reflect the changes
            }
            
            // Present the AddItemViewController
            self.present(addVC, animated: true, completion: nil)
        }
    }
    
    // Enable delete swipe action for the pantry items table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the pantryItems array
            pantryItems.remove(at: indexPath.row)
            
            // Save the updated pantryItems to UserDefaults
            PantryItem.save(pantryItems)
            
            // Reload the table view to reflect the change
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

