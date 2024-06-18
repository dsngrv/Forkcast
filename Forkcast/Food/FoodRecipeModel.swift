//
//  FoodRecipeModel.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 28.05.2024.
//

import Foundation

struct FoodRecipeModel: Identifiable, Equatable {
    
    var id: String
    var title: String
    var weatherTag: String
    var tag: String
    var instruction: String
    var ingredience: String
    var image: String
    var desriprion: String
    var isFavorite: Bool = false
    
}
