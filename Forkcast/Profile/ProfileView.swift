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
    @Environment(\.colorScheme) var colorScheme
    
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
                    
                    NavigationLink(destination: FavoritesView()) {
                        ProfileViewRow(imageName: "heart", title: "Favorites", tintColor: .red)
                    }
                }
                
                Section("App settings") {
                    HStack {
                        ProfileViewRow(imageName: colorScheme == .light ? "sun.max" : "moon", title: "App Theme", tintColor: .orange)
                        
                        Spacer()
                        
                        Toggle(" ", isOn: $isToggleOn)
                            .toggleStyle(
                                ColoredToggleStyle(onColor: Color("accent"), offColor: Color("accent"), thumbColor: Color(.white)))
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

struct ColoredToggleStyle: ToggleStyle {
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Button(action: { configuration.isOn.toggle() } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
            }
        }
    }
}

#Preview {
    ProfileView()
}
