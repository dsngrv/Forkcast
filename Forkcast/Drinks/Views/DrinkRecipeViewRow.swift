//
//  DrinkRecipeViewRow.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 17.06.2024.
//

import SwiftUI

struct DrinkRecipeViewRow: View {
    @ObservedObject var viewModel: DrinkRecipeViewModel
    @State private var isFavorite: Bool
    var recipe: DrinkRecipeModel
    
    init(viewModel: DrinkRecipeViewModel, recipe: DrinkRecipeModel) {
        self.viewModel = viewModel
        self.recipe = recipe
        _isFavorite = State(initialValue: recipe.isFavorite) // Инициализируем состояние на основе свойства рецепта
    }
    
    var body: some View {
        ZStack {
            if let url = URL(string: recipe.image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 360, height: 220)
                        .scaledToFill()
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
            }
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("rectAccent"))
                        .frame(height: 30)
                        .overlay {
                            Text(recipe.title)
                                .foregroundColor(Color("text"))
                                .font(.subheadline)
                        }
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("rectAccent"))
                        .frame(width: 90, height: 30)
                        .overlay {
                            Text(recipe.tag)
                                .foregroundColor(Color("text"))
                                .font(.caption)
                        }
                }
                .padding(.top, 10)
                .padding(10)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isFavorite.toggle()
                        viewModel.toggleFavorite(for: recipe)
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .scaledToFill()
                            .foregroundColor(.red)
                            .fontWeight(.black)
                            .padding(10)
                    }
                    .padding()
                    .frame(width: 90, height: 30)
                    .background(Color.white.opacity(0.8))
                    .shadow(radius: 5)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    .padding(10)
                }
            }
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .onReceive(viewModel.$recipes) { _ in
            isFavorite = recipe.isFavorite
        }
    }
    
    private func toggleFavoriteStatus() {
        viewModel.toggleFavorite(for: recipe)
        isFavorite.toggle()
    }
}


#Preview {
    DrinksRecipesView()
}
