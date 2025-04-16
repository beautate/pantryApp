//
//  Ingredient.swift
//  PantryApp
//
//  Created by Beau Tate on 4/8/25.
//

import Foundation


//Recipe struct that is specifically for the detail ingredients returned during second API call
//Not interchangeable with Recipe struct in Recipe.swift
struct RecipeDetail: Codable {
    var id: Int
    var title: String
    var image: String?
    var imageType: String
    var extendedIngredients: [Ingredient] = [] // Update the type to [Ingredient] instead of [String]
}
    

    struct Ingredient: Codable {
        let id: Int
        let name: String
        let image: String
        let amount: Double
        let unit: String
        let original: String
        let aisle: String
        let meta: [String]
        let measures: Measures
    }
    
    // Measures for US and Metric units
    struct Measures: Codable {
        let us: Measurement
        let metric: Measurement
    }
    
    struct Measurement: Codable {
        let amount: Double
        let unitShort: String
        let unitLong: String
    }

