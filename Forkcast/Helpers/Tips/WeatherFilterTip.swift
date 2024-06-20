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
        Text("Filter".localized)
    }
    
    var message: Text? {
        Text("You can click on this button and get a list of recipes that are suitable for the current weather".localized)
    }
}
