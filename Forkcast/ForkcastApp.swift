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
    @AppStorage("isToggleOn") private var isToggleOn = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isToggleOn ? .dark : .light)

                .environmentObject(viewModel)
                .environmentObject(foodViewModel)
                .onAppear {
                    foodViewModel.fetchData()
                    foodViewModel.fetchFavoriteRecipes()
                }
                .task {
                    //сброс типов для теста
                    try? Tips.resetDatastore()
                    //конфигурация типов
                    try? Tips.configure([
                        .displayFrequency(.daily),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
