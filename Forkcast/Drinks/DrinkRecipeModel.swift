//
//  DrinkRecipeModel.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 17.06.2024.
//

import SwiftUI

class DrinkRecipeModel: Identifiable, ObservableObject {
    
    var id: String
    var title: String
    var weatherTag: String
    var tag: String
    var instruction: [String]
    var ingredients: [String]
    var image: String
    var description: String
    @Published var isFavorite: Bool
    
    
    init(id: String, title: String, weatherTag: String, tag: String, instruction: [String], ingredients: [String], image: String, description: String, isFavorite: Bool) {
        self.id = id
        self.title = title
        self.weatherTag = weatherTag
        self.tag = tag
        self.instruction = instruction
        self.ingredients = ingredients
        self.image = image
        self.description = description
        self.isFavorite = isFavorite
    }
    
}
