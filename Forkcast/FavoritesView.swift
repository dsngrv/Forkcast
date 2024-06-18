//
//  FavoritesView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 10.06.2024.
//

import SwiftUI

struct FavoritesView: View {
    @State private var selectedCategory = "food"
    @ObservedObject var foodViewModel = FoodRecipeViewModel()
    @ObservedObject var drinkViewModel = DrinkRecipeViewModel()

    var body: some View {
        VStack {
            Picker("Выберите категорию", selection: $selectedCategory) {
                Text("Еда").tag("food")
                Text("Напитки").tag("drink")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List {
                if selectedCategory == "food" {
                    ForEach(foodViewModel.favoriteRecipes) { recipe in
                        FoodRecipeViewRow(viewModel: foodViewModel, recipe: recipe)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color("background"))
                    }
                } else {
                    Text("Drinks")
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        .onAppear {
            foodViewModel.fetchFavoriteRecipes()
            drinkViewModel.fetchFavoriteRecipes()
        }
        .background(Color("background"))
    }
}

#Preview {
    FavoritesView()
}
