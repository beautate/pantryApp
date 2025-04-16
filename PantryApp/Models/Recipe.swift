//
//  Recipe.swift
//  PantryApp
//
//  Created by Beau Tate on 4/8/25.
//

import Foundation

//Recipe struct to hold the API call results from complex search
//Not interchangeable with RecipeDetail struct from Ingredient.swift
struct Recipe: Codable {
    var id: Int
    var title: String
    var image: String?
    var imageType: String
    var extendedIngredients: [Ingredient] = [] // Update the type to [Ingredient] instead of [String]
    
    enum CodingKeys: String, CodingKey {
            case id
            case title
            case image
            case imageType
        }
}

struct RecipeResponse: Codable {
    let results: [Recipe] // Array of recipes returned by the search
}


