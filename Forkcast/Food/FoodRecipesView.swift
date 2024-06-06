//
//  FoodRecipesView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 28.05.2024.
//

import SwiftUI

struct FoodRecipesView: View {
    @StateObject private var viewModel = FoodRecipeViewModel()
    @State private var isShowingDetails = false
    @State private var searchText = ""
    @State private var selectedWeatherTag: String?

    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    CustomTextField(pholder: "Search", isSearch: true, image: "magnifyingglass", text: $searchText)
                        .padding(.leading, 20)
                    Button(action: {
                        if viewModel.isFilteringByWeather {
                            viewModel.resetFilterByWeather()
                        } else {
                            viewModel.selectedWeatherTag = selectedWeatherTag
                            viewModel.toggleFilterByWeather()
                        }
                        WeatherFilterTip().invalidate(reason: .actionPerformed)
                    }) {
                        WeatherView()
                            .padding(.trailing, 20)
                    }
                    .popoverTip(WeatherFilterTip())
                        
                }
                    
                List(viewModel.recipes) { recipe in
                    Button(action: {
                        viewModel.selectedRecipe = recipe
                        isShowingDetails = true
                    }) {
                        FoodRecipeViewRow(recipe: recipe)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color("background"))
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .sheet(isPresented: $isShowingDetails) {
                    if let selectedRecipe = viewModel.selectedRecipe {
                        FoodRecipeDetailsView(recipe: selectedRecipe)
                    }
                }
                .onAppear {
                    viewModel.fetchData()
                }
            }
            .background(Color("background"))
        }
    }
}

#Preview {
    FoodRecipesView()
}
