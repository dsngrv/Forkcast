//
//  ColoredToggle.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 20.06.2024.
//

import Foundation
import SwiftUI

struct ColoredToggleStyle: ToggleStyle {
    // Настраиваем цвет переключателя, когда он включен.
    var onColor = Color(UIColor.green)
    // Настраиваем цвет переключателя, когда он выключен.
    var offColor = Color(UIColor.systemGray5)
    // Настраиваем цвет ползунка (thumb).
    var thumbColor = Color.white

    // Данная функция определяет внешний вид и поведение переключателя.
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack { // Используем горизонтальное выравнивание для элементов.
            // Кнопка, которая переключает значение isOn.
            Button(action: { configuration.isOn.toggle() }) {
                // Настраиваем закругленный прямоугольник, который будет фоном переключателя.
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor) // Устанавливаем цвет в зависимости от состояния.
                    .frame(width: 50, height: 29) // Устанавливаем размеры переключателя.
                    .overlay(
                        // Располагаем окружность поверх прямоугольника, которая будет индикатором состояния (ползунком).
                        Circle()
                            .fill(thumbColor) // Устанавливаем цвет ползунка.
                            .shadow(radius: 1, x: 0, y: 1) // Добавляем тень для ползунка.
                            .padding(1.5) // Добавляем небольшое отступление для эстетического вида.
                            .offset(x: configuration.isOn ? 10 : -10) // Смещаем ползунок в зависимости от состояния переключателя.
                    )
            }
        }
    }
}
