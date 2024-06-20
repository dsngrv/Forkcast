//
//  TabBarButton.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 19.06.2024.
//

import SwiftUI

struct TabBarButton: View {
    let systemIconName: String
    @Binding var currentTab: Int
    let tabIndex: Int

    var body: some View {
        Button(action: {
            currentTab = tabIndex
        }) {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .padding()
                .foregroundColor(currentTab == tabIndex ? Color("accent") : Color.gray)
        }
    }
}

