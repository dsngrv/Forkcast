//
//  DrinkRecipeModel.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 17.06.2024.
//

import SwiftUI

struct DrinkRecipeModel: Identifiable, Equatable {
    
    var id: String
    var title: String
    var weatherTag: String
    var tag: String
    var instruction: [String]
    var ingredients: [String]
    var image: String
    var description: String
    var isFavorite: Bool = false
    
}
