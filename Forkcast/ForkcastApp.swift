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
 
    // Создание и привязка ViewModel для авторизации
    @StateObject var viewModel = AuthViewModel()
    
    // Использование AppStorage для хранения состояния переключателя темы (темной или светлой)
    @AppStorage("isToggleOn") private var isToggleOn = false
    
    // Использование AppStorage для хранения выбранного языка приложения
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
 
    // Инициализация приложения Firebase
    init() {
        FirebaseApp.configure()  // Конфигурация Firebase при запуске приложения
    }
 
    var body: some Scene {
        WindowGroup {
            ContentView()  // Главный view приложения
                // Установка предпочтительной цветовой схемы (темной или светлой) в зависимости от состояния переключателя
                .preferredColorScheme(isToggleOn ? .dark : .light)
                // Передача AuthViewModel через окружение (Environment Object)
                .environmentObject(viewModel)
                // Установка локали (языка) для всего приложения
                .environment(\.locale, .init(identifier: selectedLanguage))
                .task {
                    // Сброс типов данных для тестирования приложения
                    try? Tips.resetDatastore()
                    // Конфигурация подсказок (Tips) с ежедневной частотой отображения
                    try? Tips.configure([
                        .displayFrequency(.daily),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
