//
//  ProfileView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 28.05.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @AppStorage("isToggleOn") private var isToggleOn = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            Form {
                if let user = viewModel.currentUser {
                    Section {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text(user.email)
                                .font(.caption)
                                .fontWeight(.regular)
                                .accentColor(.gray)
                        }
                    }
                    
                    Button {
                        print("favor")
                    } label: {
                        ProfileViewRow(imageName: "heart", title: "Favorites", tintColor: .red)
                    }
                }
                
                Section("App settings") {
                    HStack {
                        ProfileViewRow(imageName: "sun.max", title: "App Theme", tintColor: .orange)
                        
                        Toggle(" ", isOn: $isToggleOn)
                            .foregroundColor(.white)
                    }
                }
                
                Section("Account settings") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        ProfileViewRow(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    Button {
                        Task {
                            try await viewModel.deleteAccount()
                        }
                    } label: {
                        ProfileViewRow(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("background"))
        }
    }
}


#Preview {
    ProfileView()
}
