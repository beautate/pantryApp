Original App Design Project - README Template
===

# Pantry App

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

Pantry is an app that eliminates the hassle of standing in the grocery store unable to remember whether you actually have that jar of garlic powder and having to make another trip to the store because you actually finished it three weeks ago. 
In pantry, you're able to store things that you currently have stocked, search for recipes, compare your meal plan against what you have in stock, and create a shopping list that you can then add back into your pantry as you make purchases. 

### App Evaluation

[Evaluation of your app across the following attributes]
- **Category:**
Productivity/home management
- **Mobile:**
I think that this app is extremely compatible with mobile and that the platform provides significant advantages over trying to do the same thing with desktop. I'm planning to integrate the Vision framework barcode scanner to allow users to 'stock' their pantry which is very specific to mobile. Additionally, it would be a real pain to carry a laptop around the kitchen to try to do all of this work. I think the concept is inherently mobile-centric.
- **Story:**
How compelling is the story around this app once completed?
I'm not completely impartial because I cook a lot and this is addressing an issue that I constantly run into. With that being said, I think it's far from a unique issue. How often do people end up having to make another trip to the grocery store because they could swear something was in the cabinet, but it wasn't. I think that utility apps are compelling when they cleanly fix a user frustration and make life easier and this has the ability to hit those marks well.
- **Market:**
There is an extremely large market of people who cook at home. A significant number of people who cook at home do so to save money and this app has the potential to help avoid over or repurchasing staple items that will just wither away in the pantry.
- **Habit:**
The barrier to using this app efficiently is that it needs to be used regularly to track additions/depletions in order to stay functional. This means that the UI needs to be compelling and it needs to be largely bug-free so that people don't get frustrated.


- **Scope:**
The app isn't going to be easy to build but I think that if I break it into sub-components it should stay manageable. The big parts are:

Creating the data model for the pantry and recipes
Getting my API integration for recipes right and parsing the data in a manageable way.
Figuring out how to store pantry data efficiently without building a db for the MVP.
Integrating the barcode scanner and making manual entry pretty seamless.
None of these are incredibly challenging on their own but it's going to take time and there are some things I need to give myself padding on to make sure that I don't get in a bind at the last minute trying to brute force them into working (barcode scanner). It's pretty clearly defined but I need to hit ~80% of my intended functionality to make it interesting enough to be viable.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- The ability to log in
- The ability to add an ingredient to the pantry
- An ability to remove an ingredient from the pantry
- The ability to modify the quantity of the ingredient in the pantry
- The ability to search for a recipe to cook
- The ability to view the details of that recipe
- The ability to mark a recipe as cooked and decrease the relevant quantities in the pantry
- The ability to produce a shopping list for all ingredients for recipes currently marked as to cook (persistent list of recipes and ingredients)

**Optional Nice-to-have Stories**

- The ability to scan a barcode and have basic product information populate a new or existing entry in the pantry.
- The ability to view a recipe and see what ingredients are currently stocked or need to be purchased.

### 2. Screen Archetypes

- [X] Login screen
* The ability to log in
* 
- [X] Current pantry screen
* The ability to add an ingredient to the pantry
* An ability to remove an ingredient from the pantry
* The ability to modify the quantity of the ingredient in the pantry
* ...
- [X] Item add screen (including manual add and barcode scan)
* The ability to add an ingredient to the pantry
* An ability to remove an ingredient from the pantry
* The ability to modify the quantity of the ingredient in the pantry
list second screen here]
- [X] Item detail screen (including a modify qty or remove button)
* The ability to modify the quantity of the ingredient in the pantry
- [X] Recipe search screen
* The ability to search for a recipe to cook
- [X] Recipe detail screen
* The ability to view the details of that recipe
* The ability to mark a recipe as cooked and decrease the relevant quantities in the pantry
- [X] Shopping list screen
* The ability to produce a shopping list for all ingredients for recipes currently marked as to cook (persistent list of recipes and ingredients
### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Pantry
* Recipes
* Shopping List

**Flow Navigation** (Screen to Screen)

- Login
    - Home
- Pantry
    - Add/Edit item
    - Item detail screen
- Recipes
    - Recipe search
    - Recipe detail
- Shopping List

## Wireframes

[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/beautate/pantryApp/blob/main/iOS%20Dev-2.jpg" width=600>
<img src="https://github.com/beautate/pantryApp/blob/main/iOS%20Dev-3.jpg" width=600>



## Schema 

[This section will be completed in Unit 9]

### Models
- struct PantryItem: Codable 
    var name: String
    var quantity: Double
    var unit: String

- struct Recipe: Codable 
    var id: Int
    var title: String
    var image: String?
    var imageType: String
    var extendedIngredients: [Ingredient] = [] // Update the type to [Ingredient] instead of [String]
    
-  enum CodingKeys: String, CodingKey 
            case id
            case title
            case image
            case imageType
            
- struct RecipeDetail: Codable 
    var id: Int
    var title: String
    var image: String?
    var imageType: String
    var extendedIngredients: [Ingredient] = [] // Update the type to [Ingredient] instead of [String]
    
-     struct Ingredient: Codable 
        let id: Int
        let name: String
        let image: String
        let amount: Double
        let unit: String
        let original: String
        let aisle: String
        let meta: [String]
        let measures: Measures
        
-     struct Measures: Codable 
        let us: Measurement
        let metric: Measurement
        
-     struct Measurement: Codable 
        let amount: Double
        let unitShort: String
        let unitLong: String
    
    
       

struct RecipeResponse: Codable {
    let results: [Recipe] // Array of recipes returned by the search
}

### Networking
Recipe View Controller:
Recipe search call
urlString = "https://api.spoonacular.com/recipes/complexSearch?query=\(query)&apiKey=\(apiKey)"
Recipe Detail View Controller:
Received recipe ID from Recipe View Controller and passes it in to the API call
url = URL(string: "https://api.spoonacular.com/recipes/\(recipe.id)/information?apiKey=\(apiKey)")!

- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
