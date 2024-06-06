//
//  WeatherFilterTip.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 04.06.2024.
//

import Foundation
import TipKit

struct WeatherFilterTip: Tip {
    var title: Text {
        Text("Кнопка фильтрации")
    }
    
    var message: Text? {
        Text("Вы можете нажать на кнопку с погодой и получить список рецептов, которые подойдут для текущей погоды")
    }
}
