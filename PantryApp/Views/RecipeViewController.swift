//
//  RecipeViewController.swift
//  PantryApp
//
//  Created by Beau Tate on 4/9/25.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // MARK: - Outlets and initial variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Initialize recipe arrays
    var recipes: [Recipe] = []
    var filteredRecipes: [Recipe] = []
    
    // MARK: - Search button and related API functionality

    // Debug test to help make sure that the search bar is coming into focus
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("Search bar is focused")
        return true
    }
    
    //Enable search bar cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""  // Clear the text
        filteredRecipes = recipes  // Show all recipes
        tableView.reloadData()  // Reload the table view
        
        print("Cancel button clicked")
        searchBar.resignFirstResponder()
    }
    
    // Func to trigger the API call after user inputs search text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text: \(searchText)")

        // If no search text then display current (empty) array of recipes else return filtered recipes
        if searchText.isEmpty {
            filteredRecipes = recipes // Reset to the full list
            tableView.reloadData()
            return
        }

        // Only filter recipes if search text is not empty
        filteredRecipes = recipes.filter { recipe in
            return recipe.title.lowercased().contains(searchText.lowercased())
        }

        // Reload table view with filtered recipes
        tableView.reloadData()

        
        fetchRecipes(query: searchText)
    }
    // MARK: - view loader

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test with hard coded recipes
        /*recipes = [
            Recipe(id: 1, title: "Ramen", image: "", imageType: "", ingredients: [
                Ingredient(name: "Noodles", quantity: 100, unit: "grams"),
                Ingredient(name: "Broth", quantity: 1, unit: "cup"),
                Ingredient(name: "Egg", quantity: 1, unit: "")
            ]),
            Recipe(id: 2, title: "Som Tam", image: "", imageType: "", ingredients: [
                Ingredient(name: "Papaya", quantity: 1, unit: "cup"),
                Ingredient(name: "Tomatoes", quantity: 2, unit: ""),
                Ingredient(name: "Chili", quantity: 1, unit: "tbsp")
            ])
    ]*/
        filteredRecipes = recipes
        
        // Set delegates
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        //Set the search bar as first responder so that it will take user input immediately
        searchBar.becomeFirstResponder()
        //Force cancel button to show up so that we can escape and minimize keyboard
        searchBar.showsCancelButton = true
        tableView.reloadData()
    }
    
    
    // MARK: - Fetcher
    
    // Function to query the API for recipes
    private func fetchRecipes(query: String) {
        
        //Build URL for API call
        let apiKey = "0c533d03241141d9936789d588eafc97"
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?query=\(query)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        
        let session = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Request failed: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server Error: response: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("No data returned from request")
                return
            }
            
            // Debug: Print raw response data (for inspection)
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw API response: \(responseString)") // Print the raw response for inspection
            }
            
            do {
                let decoder = JSONDecoder()
                let recipeResponse = try decoder.decode(RecipeResponse.self, from: data)
                let recipes = recipeResponse.results
                
                
                DispatchQueue.main.async {
                    self?.recipes = recipes
                    self?.filteredRecipes = recipes // Reset filtered recipes to new list
                    print("Fetched \(recipes.count) recipes")
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
    
    // MARK: - tableView functions
    
    // Return the number of rows in the table (based on the number of recipes)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    // Configure and return the cell for each recipe
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        
        let recipe = filteredRecipes[indexPath.row]
        
        cell.recipeTitleLabel.text = recipe.title
        return cell
    }
    
    // Make recipes selectable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = filteredRecipes[indexPath.row]
        //performSegue(withIdentifier: "showRecipeDetail", sender: selectedRecipe)
        print("Selected recipe: \(selectedRecipe.title)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetail" {
            if let destinationVC = segue.destination as? RecipeDetailViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let selectedRecipe = filteredRecipes[indexPath.row]
                destinationVC.selectedRecipe = selectedRecipe
            }
        }
    }
}
