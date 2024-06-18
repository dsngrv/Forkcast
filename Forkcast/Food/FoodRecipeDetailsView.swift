//
//  FoodRecipeDetailsView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 29.05.2024.
//

import SwiftUI

struct FoodRecipeDetailsView: View {
    
    var recipe: FoodRecipeModel
    let weatherTip = WeatherTip()
    
    var body: some View {
        VStack {
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
                                .popoverTip(weatherTip)
                        } else if recipe.weatherTag == "Cold" {
                            Image(systemName: "snow")
                                .foregroundColor(.blue)
                                .popoverTip(weatherTip)
                        }
                        
                    }
                }
                
                
                HStack {
                    Text("Save to favorites")
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "heart")
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
                        Text(recipe.desriprion)
                    }
                
                Section(header: Text("Ingredients")
                    .fontWeight(.semibold)) {
                        HStack {
                            Text(recipe.ingredience)
                        }
                    }
                
                Section(header: Text("Cooking instructions")
                    .fontWeight(.semibold)) {
                        Text(recipe.instruction)
                    }
                
            }
        }
    }
}


#Preview {
    FoodRecipeDetailsView(recipe: FoodRecipeModel(id: "Delicious Recipe", title: "EDA", weatherTag:  "Cold", tag: "для жары", instruction: "berem kuchu fruktov i narezaem kak vam bol'she nravitsya", ingredience: "Ingredient 1 \nIngredient 2 \nIngredient 3 \nIngredient 4", image: "https://thumbs.dreamstime.com/b/%D0%B7%D0%B4%D0%BE%D1%80%D0%BE%D0%B2%D0%B0%D1%8F-%D0%B5%D0%B4%D0%B0-%D0%B4%D0%BB%D1%8F-%D1%84%D0%B8%D1%82%D0%BD%D0%B5%D1%81%D0%B0-102707769.jpg", desriprion: "Vkusnaya fruktovaya polyana, kotoraya ideal'no podoidet vam v jarkii den'"))
}
