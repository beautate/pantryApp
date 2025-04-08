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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pantryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PantryCell", for: indexPath) as! PantryTableViewCell
        let item = pantryItems[indexPath.row]
        cell.nameLabel.text = item.name
        cell.quantityLabel.text = "\(item.quantity)"
        cell.unitLabel.text = item.unit
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected item
        let selectedItem = pantryItems[indexPath.row]
        
        // Instantiate AddItemViewController from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addVC = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as? AddItemViewController {
            //Pass selected item to the AddItemViewController
            addVC.selectedItem = selectedItem
            // Pre-fill the fields with the current item's data
            addVC.nameTextField?.text = selectedItem.name
            addVC.quantityTextField?.text = String(selectedItem.quantity)
            addVC.unitTextField?.text = selectedItem.unit
            
            // Set the onSave closure to update the item in the pantry
            addVC.onSave = { [weak self] (updatedItem: PantryItem) in
                // Update the item in the array
                self?.pantryItems[indexPath.row] = updatedItem
                
                // Save the updated list to UserDefaults
                PantryItem.save(self?.pantryItems ?? [])
                
                // Reload the table view to reflect changes
                self?.tableView.reloadData()
            }
            
            // Present the AddItemViewController
            self.present(addVC, animated: true, completion: nil)
        }
        
    }
}

