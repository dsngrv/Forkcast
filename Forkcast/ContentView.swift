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
                ProfileView()
            } else {
                LoginView()
        }
    }
}

#Preview {
    ContentView()
}
