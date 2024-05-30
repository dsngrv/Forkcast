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
        NavigationView {
            List(viewModel.recipes, id: \.id) { recipe in
                NavigationLink(destination: FoodRecipeDetailsView(recipe: recipe)) {
                    FoodRecipeViewRow(recipe: recipe)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

#Preview {
    FoodRecipesView()
}
