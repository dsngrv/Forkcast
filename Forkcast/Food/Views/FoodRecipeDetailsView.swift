//
//  FoodRecipeDetailsView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 29.05.2024.
//

import SwiftUI

struct FoodRecipeDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: FoodRecipeViewModel
    @State private var isFavorite: Bool
    var recipe: FoodRecipeModel
    
    init(viewModel: FoodRecipeViewModel, recipe: FoodRecipeModel) {
        self.viewModel = viewModel
        self.recipe = recipe
        _isFavorite = State(initialValue: recipe.isFavorite) // Инициализируем состояние на основе свойства рецепта
    }
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label:  {
                        Text("Back".localized)
                            .tint(Color("accent"))
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                
                Form {
                    
                    Section {
                        VStack {
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
                            
                            HStack {
                                Text(recipe.title)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("text"))
                            }
                        }
                         
                        Section {
                            HStack {
                                Text(isFavorite ? "Already in favorites".localized : "Save to favorites".localized)
                                    .foregroundColor(Color("text"))
                                
                                Spacer()
                                
                                Button {
                                    toggleFavoriteStatus()
                                } label: {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .scaledToFill()
                                        .foregroundColor(.red)
                                        .padding(10)
                                }
                                .frame(width: 90, height: 30)
                                .background(Color.white.opacity(0.8))
                                .shadow(radius: 5)
                                .cornerRadius(10)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listRowBackground(Color("rectAccent"))
                    
                    
                    Section(header: Text("Description".localized)
                        .fontWeight(.semibold)
                        .headerProminence(.increased)) {
                            Text(recipe.description)
                                .foregroundColor(Color("text"))
                        }
                        .listRowBackground(Color("rectAccent"))
                    
                    Section(header: Text("Ingredients".localized)
                        .fontWeight(.semibold)
                        .headerProminence(.increased)) {
                            ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                                HStack {
                                    Circle()
                                        .frame(width: 30)
                                        .foregroundColor(Color("rectAccent"))
                                        .overlay {
                                            Text("\(index + 1)")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color("text"))
                                        }
                                    Text("\(ingredient)")
                                        .foregroundColor(Color("text"))
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listRowBackground(Color.clear)

                    Section(header: Text("Cooking instructions".localized)
                        .fontWeight(.semibold)
                        .headerProminence(.increased)) {
                            ForEach(Array(recipe.instruction.enumerated()), id: \.offset) { index, step in
                                VStack {
                                    Capsule()
                                        .frame(height: 30)
                                        .foregroundColor(Color("rectAccent"))
                                        .overlay {
                                            Text("Step".localized + " " + "\(index + 1)")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color("text"))
                                        }
                                    Text("\(step)")
                                        .foregroundColor(Color("text"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .background(Color("background"))
            }
        }
    }
    
    
    private func toggleFavoriteStatus() {
        viewModel.toggleFavorite(for: recipe)
        isFavorite.toggle()
    }
}


#Preview {
    FoodRecipeDetailsView(viewModel: FoodRecipeViewModel(), recipe: FoodRecipeModel(id: "Delicious Recipe", title: "EDA", weatherTag:  "Cold", tag: "для жары", instruction: ["berem kuchu fruktov", " i narezaem kak vam bol'she nravitsya"], ingredients: ["1", "Ingredient 2", "Ingredient 3", "Ingredient 4"], image: "https://thumbs.dreamstime.com/b/%D0%B7%D0%B4%D0%BE%D1%80%D0%BE%D0%B2%D0%B0%D1%8F-%D0%B5%D0%B4%D0%B0-%D0%B4%D0%BB%D1%8F-%D1%84%D0%B8%D1%82%D0%BD%D0%B5%D1%81%D0%B0-102707769.jpg", description: "fruktovaya polyana, kotoraya ideal'no podoidet vam v jarkii den'", isFavorite: true))
}
