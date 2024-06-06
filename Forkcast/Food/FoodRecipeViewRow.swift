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
        ZStack {
            
            if let url = URL(string: recipe.image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 360, height: 220)
                        .scaledToFill()
                        .cornerRadius(10)
//                        .colorMultiply(Color("filterImage"))
                } placeholder: {
                    ProgressView()
                }
            }
            
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("accent"))
                        .frame(height: 30)
                        .overlay {
                            Text(recipe.title)
                                .font(.subheadline)
                        }
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("accent"))
                        .frame(width: 90, height: 30)
                        .overlay {
                            Text(recipe.tag)
                                .font(.caption)
                        }
                }
                .padding(.top, 10)
                .padding(10)
                
                Spacer()
                
                HStack {
                    
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
    }
}

#Preview {
    FoodRecipesView()
}
