//
//  DrinkRecipeDetailsView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 17.06.2024.
//

import SwiftUI

struct DrinkRecipeDetailsView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: DrinkRecipeViewModel
    @State private var isFavorite: Bool
    var recipe: DrinkRecipeModel
    
    init(viewModel: DrinkRecipeViewModel, recipe: DrinkRecipeModel) {
        self.viewModel = viewModel
        self.recipe = recipe
        _isFavorite = State(initialValue: recipe.isFavorite) // Инициализируем состояние на основе свойства рецепта
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Назад")
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 20)
            
            Form  {
                
                ZStack {
                    if let url = URL(string: recipe.image) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 320, height: 220)
                                .scaledToFill()
                                .cornerRadius(10)
                                .padding(.top, 8)
                                .padding(.bottom, 8)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        
                    }
                }
                
                Section {
                    HStack {
                        Text(recipe.title)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if recipe.weatherTag == "Hot" {
                            Image(systemName: "flame")
                                .foregroundColor(.orange)
                                .popoverTip(WeatherTip())
                        } else if recipe.weatherTag == "Cold" {
                            Image(systemName: "snow")
                                .foregroundColor(.blue)
                                .popoverTip(WeatherTip())
                        }
                        
                    }
                }
                
                
                HStack {
                    Text(isFavorite ? "Already in favorites" : "Save to favorites")
                    
                    Spacer()
                    
                    Button {
                        toggleFavoriteStatus()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .scaledToFill()
                            .foregroundColor(.black)
                            .padding(10)
                    }
                    .frame(width: 90, height: 30)
                    .background(Color.white.opacity(0.8))
                    .shadow(radius: 5)
                    .cornerRadius(10)
                }
                
                Section(header: Text("Description")
                    .fontWeight(.semibold)) {
                        Text(recipe.description)
                    }
                
                Section(header: Text("Ingredients")
                    .fontWeight(.semibold)) {
                        ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                                Text("\(index + 1). \(ingredient)")
                        }
                    }

                Section(header: Text("Cooking instructions")
                    .fontWeight(.semibold)) {
                        ForEach(Array(recipe.instruction.enumerated()), id: \.offset) { index, step in
                            Text("\(index + 1). \(step)")
                        }
                    }
                
            }
        }
    }
    
    private func toggleFavoriteStatus() {
        viewModel.toggleFavorite(for: recipe)
        isFavorite.toggle()
    }
}


#Preview {
    DrinkRecipeDetailsView(viewModel: DrinkRecipeViewModel(), recipe: DrinkRecipeModel(id: "Delicious Recipe", title: "EDA", weatherTag:  "Cold", tag: "для жары", instruction: ["berem kuchu fruktov i narezaem kak vam bol'she nravitsya"], ingredients: ["1 \nIngredient 2 \nIngredient 3 \nIngredient 4"], image: "https://thumbs.dreamstime.com/b/%D0%B7%D0%B4%D0%BE%D1%80%D0%BE%D0%B2%D0%B0%D1%8F-%D0%B5%D0%B4%D0%B0-%D0%B4%D0%BB%D1%8F-%D1%84%D0%B8%D1%82%D0%BD%D0%B5%D1%81%D0%B0-102707769.jpg", description: "fruktovaya polyana, kotoraya ideal'no podoidet vam v jarkii den'"))
}
