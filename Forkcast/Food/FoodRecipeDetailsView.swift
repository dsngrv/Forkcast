//
//  FoodRecipeDetailsView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 29.05.2024.
//

import SwiftUI

struct FoodRecipeDetailsView: View {
    
    var recipe: FoodRecipeModel
    
    var body: some View {
        VStack {
            Form {
                
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
                Section {
                    HStack {
                        Text(recipe.title)
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.orange)
                            .frame(width: 90, height: 30)
                            .overlay {
                                Text(recipe.tag)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            }
                    }
                }
                
                Section(header: Text("Description")
                    .fontWeight(.semibold)) {
                        Text(recipe.desriprion)
                    }
                
                Section(header: Text("Ingredients")
                    .fontWeight(.semibold)) {
                        HStack {
                            Text(recipe.ingredience)
                                .padding(.leading)
                            Spacer()
                        }
                    }
                
                Section(header: Text("Cooking instructions")
                    .fontWeight(.semibold)) {
                        Text(recipe.instruction)
                            .padding(.leading)
                    }
                
            }
        }
    }
}

#Preview {
    FoodRecipeDetailsView(recipe: FoodRecipeModel(id: "Delicious Recipe", title: "EDA", tag: "COLD", instruction: "berem kuchu fruktov i narezaem kak vam bol'she nravitsya", ingredience: "Ingredient 1 \nIngredient 2 \nIngredient 3 \nIngredient 4", image: "https://thumbs.dreamstime.com/b/%D0%B7%D0%B4%D0%BE%D1%80%D0%BE%D0%B2%D0%B0%D1%8F-%D0%B5%D0%B4%D0%B0-%D0%B4%D0%BB%D1%8F-%D1%84%D0%B8%D1%82%D0%BD%D0%B5%D1%81%D0%B0-102707769.jpg", desriprion: "Vkusnaya fruktovaya polyana, kotoraya ideal'no podoidet vam v jarkii den'"))
}
