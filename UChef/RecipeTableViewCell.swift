//
//  RecipeTableViewCell.swift
//  UChef
//
//  Created by Vicky Liu on 7/19/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        super.backgroundColor = .clear
    }
    
    
}
