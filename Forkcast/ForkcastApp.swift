//
//  ForkcastApp.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 27.05.2024.
//

import FirebaseCore
import SwiftUI
import TipKit

@main
struct ForkcastApp: App {
    
    @StateObject private var foodViewModel = FoodRecipeViewModel()
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(foodViewModel)
                .onAppear {
                    foodViewModel.fetchData()
                    foodViewModel.fetchFavoriteRecipes()
                }
                .task {
                    try? Tips.resetDatastore()
                    try? Tips.configure([
                        .displayFrequency(.daily),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
