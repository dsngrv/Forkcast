//
//  CustomTextField.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 27.05.2024.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    // Определяем типы полей ввода с помощью перечисления (enum)
    enum FieldType {
        case secure, email, search, normal
    }
    
    // Параметры для настройки компонента
    var pholder: String // Placeholder текста
    var fieldType: FieldType // Тип поля ввода
    var image: String // Имя изображения для иконки
    @Binding var text: String // Связка введенного текста
    @FocusState var isEnabled: Bool // Состояние фокуса
    
    var body: some View {
        // Определяем вид закругленного прямоугольника для обертки поля ввода
        let roundedRectangle = RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 2)
            .foregroundColor(Color("accent"))
            .frame(height: 50)
        
        // Основной контейнер HStack
        HStack {
            // Добавляем иконку слева
            Image(systemName: image)
                .foregroundColor(Color("accent"))
                .padding(10)
            
            // Используем switch для отображения разных типов текстовых полей
            switch fieldType {
            case .secure:
                // Секретное поле (для паролей)
                SecureField(pholder, text: $text)
                    .keyboardType(.default)
                    .focused($isEnabled)
                    .textContentType(.password)
                
                // Иконка справа для отображения валидности пароля
                if !text.isEmpty {
                    Image(systemName: text.isValidPassword(password: text) ? "checkmark" : "xmark")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color("text"))
                        .padding(.trailing ,10)
                }
                
            case .email:
                // Поле для ввода email
                TextField(pholder, text: $text)
                    .keyboardType(.emailAddress)
                    .focused($isEnabled)
                    .textInputAutocapitalization(.never)
                    .textContentType(.emailAddress)
                
                // Иконка справа для отображения валидности email
                if !text.isEmpty {
                    Image(systemName: text.isValidMail(email: text) ? "checkmark" : "xmark")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color("text"))
                        .padding(.trailing ,10)
                }
                
            case .search:
                // Поле для поиска
                TextField(pholder, text: $text)
                    .keyboardType(.default)
                    .focused($isEnabled)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.none)
                
                // Удаление текста при нажатии на иконку "крестик"
                if !text.isEmpty {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("text"))
                        .padding(.trailing ,10)
                        .onTapGesture {
                            text = ""
                        }
                }
                
            case .normal:
                // Обычное текстовое поле
                TextField(pholder, text: $text)
                    .keyboardType(.default)
                    .focused($isEnabled)
                    .textContentType(.none)
            }
        }
        .background(
            // Применяем фон стиля закругленного прямоугольника
            roundedRectangle)
    }
}

#Preview {
    LoginView()
}
