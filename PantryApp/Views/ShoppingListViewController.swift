//
//  ShoppingListViewController.swift
//  PantryApp
//
//  Created by Beau Tate on 4/15/25.
//

import UIKit

class ShoppingListViewController: UIViewController, (UITableViewDataSource), (UITableViewDelegate) {
    
    // MARK: - Outlets and variables
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clearPurchasedItems(_ sender: Any) {
        savePurchasedItems([]) // Clear the purchased items
        shoppingList = compareIngredientsAgainstPantry()
        // Refresh the list
        tableView.reloadData()
    }
    
    private var shoppingList: [(recipe: RecipeDetail, missingIngredients: [(name: String, requiredAmount: Double, unit: String, availableAmount: Double)])] = []
    
    var pantryItems: [PantryItem] = []
    
    // Struct to represent a purchased item
    struct PurchasedItem: Codable, Equatable {
        let recipeId: Int
        let ingredientName: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.title = "Shopping List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoppingList = compareIngredientsAgainstPantry()
        print("Pantry tab viewWillAppear called")
        pantryItems = PantryItem.load()
        print("Pantry items loaded in viewWillAppear: \(pantryItems.map { "\($0.name): \($0.quantity) \($0.unit)" })")
        tableView.reloadData()
    }

    
    
    // MARK: - TableView Data source and delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList[section].missingIngredients.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shoppingList[section].recipe.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath)
        
        let missingIngredient = shoppingList[indexPath.section].missingIngredients[indexPath.row]
        let needed = missingIngredient.requiredAmount - missingIngredient.availableAmount
        cell.textLabel?.text = "\(missingIngredient.name): Need \(needed) \(missingIngredient.unit)"
        cell.detailTextLabel?.text = "Required: \(missingIngredient.requiredAmount), Available: \(missingIngredient.availableAmount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = shoppingList[indexPath.section]
        let recipeId = result.recipe.id
        let missingIngredient = result.missingIngredients[indexPath.row]
        
        // Mark the ingredient as purchased
        var purchasedItems = loadPurchasedItems()
        let purchasedItem = PurchasedItem(recipeId: recipeId, ingredientName: missingIngredient.name)
        purchasedItems.append(purchasedItem)
        savePurchasedItems(purchasedItems)
        
        // Add the item to the pantry
        addToPantry(ingredient: missingIngredient)
        
        // Remove the ingredient from the displayed list
        shoppingList[indexPath.section].missingIngredients.remove(at: indexPath.row)
        
        // If the section is now empty, remove the entire section
        if shoppingList[indexPath.section].missingIngredients.isEmpty {
            shoppingList.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: -Pantry and comparison logic
    //Load recipes that user has saved as 'to cook'
    private func loadToCookRecipes() -> [RecipeDetail] {
        guard let data = UserDefaults.standard.data(forKey: "ToCookRecipes"),
              let decoded = try? JSONDecoder().decode([RecipeDetail].self, from: data)
        else {
            print("No To Cook recipes found in UserDefaults")
            return []
        }
        
        print("Loaded To Cook recipes: \(decoded.map { $0.title })")
        for recipe in decoded {
            let ingredients = recipe.extendedIngredients.map { "\($0.name): \($0.amount) \($0.unit)" }
            print("Recipe: \(recipe.title), Ingredients: \(ingredients)")
        }
        
        return decoded
    }
    
    //Load items that are currently in pantry
    private func loadPantryItems() -> [PantryItem] {
        guard let data = UserDefaults.standard.data(forKey: "pantryItems") else {
            print("No pantry items data found in UserDefaults")
            return []
        }
        
        do {
            let decoded = try JSONDecoder().decode([PantryItem].self, from: data)
            print("Successfully loaded pantry items: \(decoded.map { "\($0.name): \($0.quantity) \($0.unit)" })")
            return decoded
        } catch {
            print("Failed to decode pantry items: \(error)")
            return []
        }
    }
    
    //Save items to pantry
    private func savePantryItems(_ items: [PantryItem]) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(items)
            UserDefaults.standard.set(encoded, forKey: "pantryItems")
            print("Successfully saved pantry items: \(items.map { "\($0.name): \($0.quantity) \($0.unit)" })")
        } catch {
            print("Failed to encode pantry items: \(error)")
        }
    }
    
    //Add items to pantry after removing from shopping list
    private func addToPantry(ingredient: (name: String, requiredAmount: Double, unit: String, availableAmount: Double)) {
        var pantryItems = loadPantryItems()
        print("Loaded pantry items before update: \(pantryItems.map { "\($0.name): \($0.quantity) \($0.unit)" })")
        
        if let existingIndex = pantryItems.firstIndex(where: { $0.name.lowercased() == ingredient.name.lowercased() }) {
            let neededAmount = ingredient.requiredAmount - ingredient.availableAmount
            pantryItems[existingIndex].quantity += neededAmount
            print("Updated \(ingredient.name) in pantry: \(pantryItems[existingIndex].quantity) \(ingredient.unit)")
        } else {
            let newItem = PantryItem(name: ingredient.name, quantity: ingredient.requiredAmount, unit: ingredient.unit)
            pantryItems.append(newItem)
            print("Added \(ingredient.name) to pantry: \(ingredient.requiredAmount) \(ingredient.unit)")
        }
        
        print("Saving pantry items: \(pantryItems.map { "\($0.name): \($0.quantity) \($0.unit)" })")
        savePantryItems(pantryItems)
        
        let reloadedItems = loadPantryItems()
        print("Pantry items after save: \(reloadedItems.map { "\($0.name): \($0.quantity) \($0.unit)" })")
        
        
    }
    
    // Evaluate the difference between what's saved in toCook recipes vs. what's currently contained in the pantry
    private func compareIngredientsAgainstPantry() -> [(recipe: RecipeDetail, missingIngredients: [(name: String, requiredAmount: Double, unit: String, availableAmount: Double)])] {
        let toCookRecipes = loadToCookRecipes()
        let pantryItems = loadPantryItems()
        let purchasedItems = loadPurchasedItems()
        
        var comparisonResults: [(recipe: RecipeDetail, missingIngredients: [(name: String, requiredAmount: Double, unit: String, availableAmount: Double)])] = []
        
        for recipe in toCookRecipes {
            var missingIngredients: [(name: String, requiredAmount: Double, unit: String, availableAmount: Double)] = []
            
            for ingredient in recipe.extendedIngredients {
                if purchasedItems.contains(where: { $0.recipeId == recipe.id && $0.ingredientName.lowercased() == ingredient.name.lowercased() }) {
                    continue
                }
                //Core logic to evaluate the difference between required and available and add to missing ingredients if necessary
                if let pantryItem = pantryItems.first(where: { $0.name.lowercased() == ingredient.name.lowercased() }) {
                    let requiredAmount = ingredient.amount
                    let availableAmount = pantryItem.quantity
                    if availableAmount < requiredAmount {
                        missingIngredients.append((name: ingredient.name, requiredAmount: requiredAmount, unit: ingredient.unit, availableAmount: availableAmount))
                    }
                } else {
                    missingIngredients.append((name: ingredient.name, requiredAmount: ingredient.amount, unit: ingredient.unit, availableAmount: 0.0))
                }
            }
            
            if !missingIngredients.isEmpty {
                comparisonResults.append((recipe: recipe, missingIngredients: missingIngredients))
            }
        }
        
        return comparisonResults
    }
    
    // MARK: - Purchased Items Persistence
    
    //Decode items from purchased items list from user defaults
    private func loadPurchasedItems() -> [PurchasedItem] {
        guard let data = UserDefaults.standard.data(forKey: "PurchasedItems"),
              let decoded = try? JSONDecoder().decode([PurchasedItem].self, from: data)
        else {
            return []
        }
        return decoded
    }
    
    //Encode purchase items and save them to user defaults
    private func savePurchasedItems(_ items: [PurchasedItem]) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(items)
            UserDefaults.standard.set(encoded, forKey: "PurchasedItems")
            print("Saved Purchased Items: \(items.map { "\($0.ingredientName) (Recipe ID: \($0.recipeId))" })")
        } catch {
            print("Error encoding Purchased Items: \(error)")
        }
    }
}
