
//
//  RecipeDetailViewController.swift
//  PantryApp
//
//  Created by Beau Tate on 4/12/25.
//

import UIKit

class RecipeDetailViewController: UIViewController, (UITableViewDataSource), (UITableViewDelegate) {
    
    // MARK: - Outlets and variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    var selectedRecipe: Recipe?
    
    
    //Mark: -View loading
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let recipe = selectedRecipe else {
            print("No recipe selected!")
            return
        }
        
        recipeTitleLabel.text = recipe.title
        if let imageUrlString = recipe.image, let url = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.recipeImageView.image = UIImage(data: data)
                    }
                }
            }
        }
        //Call to API query for the detailed recipe that was passed in from RVC
        fetchDetailedRecipeInfo(for: recipe) { [weak self] detailedRecipe in
            guard let _ = detailedRecipe else {
                print("Failed to fetch detailed recipe info")
                return
            }
            self?.updateToCookButtonAppearance()
        }
        tableView.reloadData()
    }
    
    // MARK: - TableView methods
    //Numrows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedRecipe?.extendedIngredients.count ?? 0)
    }
    //Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailCell", for: indexPath) as! RecipeDetailTableViewCell
        
        guard let recipe = selectedRecipe else {
            return UITableViewCell()
        }
        
        let ingredient = recipe.extendedIngredients[indexPath.row]
        cell.ingredientNameLabel.text = ingredient.name
        cell.ingredientQuantityLabel.text = "\(ingredient.amount)"
        cell.ingredientUnitLabel.text = ingredient.unit
        
        return cell
    }
    
    //ability to select row for further functionality
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recipe = selectedRecipe {
            print("Selected recipe: \(recipe.title)")
        }
    }
    
    // MARK: - Fetcher
    func fetchDetailedRecipeInfo(for recipe: Recipe, completion: @escaping (RecipeDetail?) -> Void) {
        //Declare session and set code URL query and API key
        let session = URLSession.shared
        let apiKey = "0c533d03241141d9936789d588eafc97"
        let url = URL(string: "https://api.spoonacular.com/recipes/\(recipe.id)/information?apiKey=\(apiKey)")!
        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching detailed recipe: \(String(describing: error))")
                completion(nil)
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw API response: \(responseString)")
            }
            
            //Initialize decoder
            let decoder = JSONDecoder()
            do {
                let detailedRecipe = try decoder.decode(RecipeDetail.self, from: data)
                
                print("Fetched detailed recipe: \(detailedRecipe.title)")
                
                let ingredients = detailedRecipe.extendedIngredients.map { "\($0.name): \($0.amount) \($0.unit)" }
                print("Ingredients for \(detailedRecipe.title): \(ingredients)")
                
                DispatchQueue.main.async {
                    //Populate necessary attributes
                    self?.selectedRecipe?.title = detailedRecipe.title
                    self?.selectedRecipe?.image = detailedRecipe.image
                    self?.selectedRecipe?.extendedIngredients = detailedRecipe.extendedIngredients
                    self?.tableView.reloadData()
                    completion(detailedRecipe)
                }
            } catch {
                print("Error decoding detailed recipe: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    // MARK: - To Cook Functionality
    
    //Action outlet to register the to cook tap
    @IBAction func toCookButtonTapped(_ sender: UIBarButtonItem) {
        let originalTint = sender.tintColor
        sender.tintColor = .gray
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.tintColor = originalTint
        }
        
        print("To cook button tapped")
        toggleToCookStatus()
    }
    // Switch between to-cook states
    private func toggleToCookStatus() {
        print("toggleToCookStatus called")
        
        guard let recipe = selectedRecipe else {
            print("No recipe selected, returning")
            return
        }
        
        print("Fetching detailed recipe info for \(recipe.title)")
        fetchDetailedRecipeInfo(for: recipe) { [weak self] detailedRecipe in
            guard let detailedRecipe = detailedRecipe else {
                print("Failed to fetch detailed recipe info for \(recipe.title)")
                return
            }
            self?.saveRecipeToToCookList(detailedRecipe)
        }
    }
    
    //Add or remove recipe to to-cook list depending on whether it exists there already
    private func saveRecipeToToCookList(_ detailedRecipe: RecipeDetail) {
        var toCookRecipes = loadToCookRecipes()
        
        if toCookRecipes.contains(where: { $0.id == detailedRecipe.id }) {
            toCookRecipes.removeAll { $0.id == detailedRecipe.id }
            print("Removed \(detailedRecipe.title) from To Cook list")
        } else {
            toCookRecipes.append(detailedRecipe)
            print("Added \(detailedRecipe.title) to To Cook list")
        }
        
        saveToCookRecipes(toCookRecipes)
        
        //Display the current list of to-cook recipes
        let updatedList = loadToCookRecipes()
        print("After toggle, To Cook list: \(updatedList.map { $0.title })")
        
        updateToCookButtonAppearance()
    }
    
    //Function that pulls from array of to cook recipes
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
    
    //Encode recipe and save details
    private func saveToCookRecipes(_ recipes: [RecipeDetail]) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(recipes)
            UserDefaults.standard.set(encoded, forKey: "ToCookRecipes")
            print("Saved To Cook recipes: \(recipes.map { $0.title })")
        } catch {
            print("Error encoding To Cook recipes: \(error)")
        }
    }
    
    //Change to cook button's appearance depending on state. Not fully functional.
    private func updateToCookButtonAppearance() {
        print("updateToCookButtonAppearance called")
        
        guard let recipe = selectedRecipe else {
            print("No recipe for button update")
            return
        }
        
        let toCookRecipes = loadToCookRecipes()
        let isToCook = toCookRecipes.contains(where: { $0.id == recipe.id })
        
        print("isToCook: \(isToCook)")
        
        navigationItem.rightBarButtonItem?.title = isToCook ? "Remove To Cook" : "To Cook"
        navigationItem.rightBarButtonItem?.tintColor = isToCook ? .systemRed : .systemBlue
    }
}
