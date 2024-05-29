//
//  FoodRecipesView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 28.05.2024.
//

import SwiftUI

struct FoodRecipesView: View {
    @ObservedObject private var viewModel = FoodRecipeViewModel()

    var body: some View {
        List(viewModel.recipes, id: \.id) { recipe in
            FoodRecipeViewRow(recipe: recipe)
            
//                .listRowBackground()
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.fetchData()
        }
    }
}

#Preview {
    FoodRecipesView()
}
