//
//  WeatherTip.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 04.06.2024.
//

import Foundation
import TipKit

struct WeatherTip: Tip {
    var title: Text {
        Text("Подсказка")
    }
    
    var message: Text? {
        Text("Иконка показывает для какой погоды походит это блюдо")
    }
}
