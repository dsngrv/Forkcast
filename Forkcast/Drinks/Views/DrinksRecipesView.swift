//
//  DrinksRecipesView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 17.06.2024.
//

import SwiftUI

struct DrinksRecipesView: View {
    @StateObject private var viewModel = DrinkRecipeViewModel()
    @State private var isShowingDetails = false
    @State private var searchText = ""
    @State private var selectedWeatherTag: String?

    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    CustomTextField(pholder: "Search".localized, fieldType: .search, image: "magnifyingglass", text: $searchText)
                        .padding(.leading, 20)
                        .padding(.top, 2)
                        .onChange(of: searchText) {
                                                    viewModel.filterRecipes(with: searchText)
                                                }
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
                            .padding(.top, 2)
                    }
                }
                
                if viewModel.isFilteringByWeather {
                    Text("Filtered by current weather".localized)
                                        .foregroundColor(.gray)
                                        .padding(.top, 10)
                                }
                    
                List(viewModel.filteredRecipes) { recipe in
                    Button(action: {
                        viewModel.selectedRecipe = recipe
                        isShowingDetails = true
                    }) {
                        DrinkRecipeViewRow(viewModel: viewModel, recipe: recipe)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color("background"))
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .fullScreenCover(isPresented: $isShowingDetails) {
                    if let selectedRecipe = viewModel.selectedRecipe {
                        DrinkRecipeDetailsView(viewModel: viewModel, recipe: selectedRecipe)
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
    DrinksRecipesView()
}
