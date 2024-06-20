//
//  AuthViewModel.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 28.05.2024.
//

import Firebase
import FirebaseAuth
import Foundation

// Протокол для проверки валидности формы
protocol AuthFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    
    /// Published - реагирует на изменения и обновляет интерфейс в реальном времени
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    // Инициализатор ViewModel, который проверяет текущую сессию пользователя при запуске
    init() {
        // Проверка текущего пользователя Firebase
        self.userSession = Auth.auth().currentUser
        
        Task {
            // Асинхронный вызов для получения информации о пользователе из Firestore
            await fetchUser()
        }
    }
    
    // Функция для выполнения аутентификации пользователя через email и пароль
    func signIn(withEmail email: String, password: String) async throws {
        do {
            // Вход в Firebase с использованием email и пароля
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            // Сохранение текущей сессии пользователя
            self.userSession = result.user
            // Обновление информации о пользователе
            await fetchUser()
        } catch {
            // Обработка ошибок при входе
            print("Fail to log in with error: \(error.localizedDescription)")
        }
    }
    
    // Функция для создания нового пользователя
    func createUser(withEmail email: String, password: String, name: String) async throws {
        do {
            // Создание пользователя в Firebase
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // Сохранение текущей сессии пользователя
            self.userSession = result.user
            // Создание объекта пользователя
            let user = User(id: result.user.uid, name: name, email: email)
            // Кодирование объекта пользователя для сохранения в Firestore
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            // Обновление информации о пользователе
            await fetchUser()
        } catch {
            // Обработка ошибок при создании пользователя
            print("Fail to create user with error: \(error.localizedDescription)")
        }
    }
    
    // Функция для выхода из системы пользователя
    func signOut() {
        do {
            // Выход из Firebase
            try Auth.auth().signOut()
            // Обнуление текущей сессии и информации о пользователе
            self.userSession = nil
            self.currentUser = nil
        } catch {
            // Обработка ошибок при выходе
            print("Failed to sign out with error \(error.localizedDescription)")
        }
        print("sign out")
    }
    
    // Функция для удаления аккаунта пользователя
    func deleteAccount() async throws {
        do {
            // Получение текущего пользователя
            let user = Auth.auth().currentUser
            // Удаление текущего пользователя
            try await user?.delete()
            // Обнуление сессии и информации о пользователе
            self.userSession = nil
            self.currentUser = nil
        } catch {
            // Обработка ошибок при удалении пользователя
            print("Deleting failed with error \(error.localizedDescription)")
        }
    }
    
    // Функция для получения информации о пользователе из Firestore
    func fetchUser() async {
        // Получение UID текущего пользователя
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Получение документа пользователя из Firestore
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        // Декодирование и сохранение информации о текущем пользователе
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
