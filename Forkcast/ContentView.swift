//
//  ContentView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 27.05.2024.
//

import FirebaseAuth
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
        
    var body: some View {
        
        if viewModel.userSession != nil {
                TabView {
                    FoodRecipesView()
                        .tabItem {
                            Label("Food", systemImage: "fork.knife")
                        }
                    
                    Text("Drinks")
                        .tabItem {
                            Label("Drinks", systemImage: "mug.fill")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }
            } else {
                LoginView()
        }
    }
}

#Preview {
    ContentView()
}
