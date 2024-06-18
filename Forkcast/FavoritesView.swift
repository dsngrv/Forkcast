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
    @State private var isShowingDetails = false
    @State private var selectedFoodRecipe: FoodRecipeModel?
    @State private var selectedDrinkRecipe: DrinkRecipeModel?


    var body: some View {
        VStack {
            Picker("Выберите категорию", selection: $selectedCategory) {
                Text("Еда").tag("food")
                Text("Напитки").tag("drink")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedCategory == "food" {
                List {
                    ForEach(foodViewModel.favoriteRecipes, id: \.id) { recipe in
                        Button(action: {
                            self.selectedFoodRecipe = recipe
                            self.isShowingDetails = true
                            // Отладочный вывод
                            print("Выбранный рецепт: \(recipe.title)")
                        }) {
                            FoodRecipeViewRow(viewModel: foodViewModel, recipe: recipe)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
                .fullScreenCover(isPresented: $isShowingDetails) {
                    if let recipe = selectedFoodRecipe {
                        FoodRecipeDetailsView(viewModel: foodViewModel, recipe: recipe)
                    } else {
                        Text("Нет выбранного рецепта") // Для отладки
                    }
                }
            } else if selectedCategory == "drink" {
                List {
                    ForEach(drinkViewModel.favoriteRecipes, id: \.id) { recipe in
                        Button(action: {
                            self.selectedDrinkRecipe = recipe
                            self.isShowingDetails = true
                            // Отладочный вывод
                            print("Выбранный рецепт: \(recipe.title)")
                        }) {
                            DrinkRecipeViewRow(viewModel: drinkViewModel, recipe: recipe)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
                .fullScreenCover(isPresented: $isShowingDetails) {
                    if let recipe = selectedDrinkRecipe {
                        DrinkRecipeDetailsView(viewModel: drinkViewModel, recipe: recipe)
                    } else {
                        Text("Нет выбранного рецепта") // Для отладки
                    }
                }
            }
        }
        .onAppear {
            foodViewModel.fetchData()  // Загружаем данные при появлении представления
            drinkViewModel.fetchData()
        }
        .onChange(of: isShowingDetails) {
            // Дополнительный лог для проверки изменения состояния
            print("isShowingDetails изменился на: \(isShowingDetails)")
        }
    }
}

#Preview {
    FavoritesView()
}
