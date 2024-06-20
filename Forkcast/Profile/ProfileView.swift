//
//  ProfileView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 28.05.2024.
//

import SwiftUI

import SwiftUI

struct ProfileView: View {
 
    @AppStorage("isToggleOn") private var isToggleOn = false
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
 
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
 
    let availableLanguages = ["en", "ru"]
 
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
                        .listRowBackground(Color("rectAccent"))
                    }
 
                    NavigationLink(destination: FavoritesView()) {
                        ProfileViewRow(imageName: "heart.fill", title: "Favorites".localized, tintColor: .red)
                    }
                    .listRowBackground(Color("rectAccent"))
                }
                
 
                Section(header: Text("App settings".localized)) {
                    HStack {
                        ProfileViewRow(imageName: colorScheme == .light ? "sun.max" : "moon", title: "App Theme".localized, tintColor: .orange)
 
                        Spacer()
 
                        Toggle("", isOn: $isToggleOn)
                            .toggleStyle(
                                ColoredToggleStyle(onColor: .black, offColor: .gray, thumbColor: Color(.white))
                            )
                    }
 
                    HStack {
                        ProfileViewRow(imageName: "globe", title: "Language".localized, tintColor: .orange)
                        
                        Spacer()
                        

                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                            .frame(width: 110, height: 26)
                            .overlay {
                                Picker("", selection: $selectedLanguage) {
                                    ForEach(availableLanguages, id: \.self) { lang in
                                        Text(languageName(for: lang)).tag(lang)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                    }
                }
                .listRowBackground(Color("rectAccent"))
 
                Section(header: Text("Account settings".localized)) {
                    Button {
                        viewModel.signOut()
                    } label: {
                        ProfileViewRow(imageName: "arrow.left.circle.fill", title: "Sign Out".localized, tintColor: .red)
                    }
                    Button {
                        Task {
                            try await viewModel.deleteAccount()
                        }
                    } label: {
                        ProfileViewRow(imageName: "xmark.circle.fill", title: "Delete Account".localized, tintColor: .red)
                    }
                }
                .listRowBackground(Color("rectAccent"))
            }
            .scrollContentBackground(.hidden)
            .background(Color("background"))
        }
    }
 
    // Функция для преобразования кода языка в его название
    private func languageName(for code: String) -> String {
        let locale = Locale(identifier: code)
        return locale.localizedString(forLanguageCode: code) ?? code
    }
}

#Preview {
    ProfileView()
}
