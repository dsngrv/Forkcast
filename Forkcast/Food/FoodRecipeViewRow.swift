//
//  FoodRecipeViewRow.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 28.05.2024.
//

import SwiftUI

struct FoodRecipeViewRow: View {
    
    var recipe: FoodRecipeModel
    
    var body: some View {
        VStack {
            
            HStack {
                Text(recipe.title)
                    .font(.title)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.orange)
                    .frame(width: 90, height: 30)
                    .overlay {
                        Text("Tag")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
            }
            .padding(10)
            
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
            
            Text(recipe.desriprion)
                .font(.callout)
                .padding(10)
            
            Button {
                
            } label: {
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .scaledToFill()
                    .foregroundColor(.black)
                    .padding(10)
            }
            
        }
        .padding(8)
        .background()
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

#Preview {
    FoodRecipesView()
}
