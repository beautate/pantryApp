//
//  RecipeDetailTableViewCell.swift
//  PantryApp
//
//  Created by Beau Tate on 4/12/25.
//

import UIKit

class RecipeDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var ingredientQuantityLabel: UILabel!
    @IBOutlet weak var ingredientUnitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Ingredient Name Label
        ingredientNameLabel.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        ingredientNameLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        ingredientNameLabel.numberOfLines = 0 // Allow wrapping
        
        // Ingredient Quantity Label
        ingredientQuantityLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        ingredientQuantityLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        ingredientQuantityLabel.textAlignment = .right
        
        // Ingredient Unit Label
        ingredientUnitLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        ingredientUnitLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        ingredientUnitLabel.textAlignment = .right
        
        // Force layout update
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
