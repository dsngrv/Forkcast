//
//  CustomTabBar.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 19.06.2024.
//

import SwiftUI

struct CustomTabBar: View {
    @State private var currentTab: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Контент текущей вкладки
            switch currentTab {
            case 0:
                FoodRecipesView()
            case 1:
                DrinksRecipesView()
            case 2:
                ProfileView()
            default:
                FoodRecipesView()
            }

            // Кастомный таб-бар
            HStack {
                Spacer(minLength: 10)
                TabBarButton(systemIconName: "fork.knife", currentTab: $currentTab, tabIndex: 0)
                Spacer()
                TabBarButton(systemIconName: "mug.fill", currentTab: $currentTab, tabIndex: 1)
                Spacer()
                TabBarButton(systemIconName: "person.fill", currentTab: $currentTab, tabIndex: 2)
                Spacer(minLength: 10)

            }
            .padding(.top, 8)
            .padding(.bottom, 14)
            .background(Color("background").shadow(radius: 5))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
#Preview {
    CustomTabBar()
}
