//
//  PantryItem.swift
//  PantryApp
//
//  Created by Beau Tate on 4/8/25.
//
import Foundation

struct PantryItem: Codable {
    var name: String
    var quantity: Double
    var unit: String
}

extension PantryItem {
    private static let pantryKey = "pantryItems"
    
    //Helper to save an item to persistent memory (UserDefaults)
    static func save(_ items: [PantryItem]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: pantryKey)
        }
        }
    
    
   //Helper to retrieve an item from persistent memory (UserDefaults)
    static func load() -> [PantryItem] {
        guard let data = UserDefaults.standard.data(forKey: pantryKey),
              let decoded = try? JSONDecoder().decode([PantryItem].self, from: data)
        else {
            return []
        }
        return decoded
    }
}
