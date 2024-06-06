//
//  ProfileViewRow.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 28.05.2024.
//

import SwiftUI

struct ProfileViewRow: View {
    
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color("accent"))
        }
    }
}

#Preview {
    ProfileViewRow(imageName: "gear", title: "Settings", tintColor: Color.gray)
}
