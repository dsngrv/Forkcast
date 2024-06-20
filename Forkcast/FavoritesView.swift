//
//  FavoritesView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 10.06.2024.
//

import SwiftUI

struct FavoritesView: View {
    // State для хранения выбранной категории (еда или напитки)
    @State private var selectedCategory = "food"
    
    // ObservedObject для отслеживания изменений в ViewModel для рецептов еды
    @ObservedObject var foodViewModel = FoodRecipeViewModel()
    
    // ObservedObject для отслеживания изменений в ViewModel для рецептов напитков
    @ObservedObject var drinkViewModel = DrinkRecipeViewModel()
    
    // State для управления состоянием отображения деталей рецепта
    @State private var isShowingDetails = false
    
    // State для хранения выбранного рецепта еды
    @State private var selectedFoodRecipe: FoodRecipeModel?
    
    // State для хранения выбранного рецепта напитка
    @State private var selectedDrinkRecipe: DrinkRecipeModel?
    
    // Настройка внешнего вида UISegmentedControl
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "accent")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(named: "text") ?? .black], for: .selected)
    }

    var body: some View {
        VStack {
            // Использование Picker для выбора категории
            Picker("Category".localized, selection: $selectedCategory) {
                Text("Food".localized).tag("food")
                    .foregroundColor(Color("text"))
                Text("Drinks".localized).tag("drink")
                    .foregroundColor(Color("text"))
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedCategory == "food" {
                // Если выбрана категория "еда"
                List {
                    // Отображение списка избранных рецептов еды
                    ForEach(foodViewModel.favoriteRecipes, id: \.id) { recipe in
                        Button(action: {
                            // При нажатии сохраняем выбранный рецепт и отображаем детали
                            self.selectedFoodRecipe = recipe
                            self.isShowingDetails = true
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
                    // Отображаем детали рецепта в полноэкранном режиме
                    if let recipe = selectedFoodRecipe {
                        FoodRecipeDetailsView(viewModel: foodViewModel, recipe: recipe)
                    } else {
                        Text("Нет выбранного рецепта")
                    }
                }
            } else if selectedCategory == "drink" {
                // Если выбрана категория "напитки"
                List {
                    // Отображение списка избранных рецептов напитков
                    ForEach(drinkViewModel.favoriteRecipes, id: \.id) { recipe in
                        Button(action: {
                            // При нажатии сохраняем выбранный рецепт и отображаем детали
                            self.selectedDrinkRecipe = recipe
                            self.isShowingDetails = true
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
                    // Отображаем детали рецепта в полноэкранном режиме
                    if let recipe = selectedDrinkRecipe {
                        DrinkRecipeDetailsView(viewModel: drinkViewModel, recipe: recipe)
                    } else {
                        Text("Нет выбранного рецепта")
                    }
                }
            }
        }
        .onAppear {
            // Загружаем данные при появлении представления
            foodViewModel.fetchData()
            drinkViewModel.fetchData()
        }
        .onChange(of: isShowingDetails) {
            // Дополнительный лог для проверки изменения состояния
            print("isShowingDetails изменился на: \(isShowingDetails)")
        }
        .background(Color("background")) // Установка фона представления
        .navigationBarTitleDisplayMode(.inline) // Установка режима отображения заголовка навигационного бара
    }
}
#Preview {
    FavoritesView()
}
