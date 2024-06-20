//
//  ContentView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 27.05.2024.
//

import FirebaseAuth
import SwiftUI

struct ContentView: View {
    
    // Внедрение объекта окружения для доступа к AuthViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    
    // Инициализатор для скрытия стандартного Tab Bar
    init() {
        UITabBar.appearance().isHidden = true
    }
        
    var body: some View {
        
        // Проверка, существует ли сессия пользователя
        if viewModel.userSession != nil {
            // Если сессия есть, отображаем CustomTabBar с заданным цветом акцента
            CustomTabBar()
                .accentColor(Color("accent"))
        } else {
            // Если сессии нет, отображаем LoginView
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
