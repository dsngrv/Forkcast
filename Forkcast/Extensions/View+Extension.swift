//
//  View+Extension.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 27.05.2024.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
