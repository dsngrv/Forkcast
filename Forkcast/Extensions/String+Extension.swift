//
//  String+Extension.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 18.06.2024.
//

import Foundation

// Локализация строки на основе текущего языка
extension String {
    var localized: String {
        let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Locale.current.language.languageCode?.identifier ?? "en"
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: self)
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: self)
    }
}
