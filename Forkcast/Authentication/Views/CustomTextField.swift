//
//  CustomTextField.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 27.05.2024.
//

import Foundation

import SwiftUI

struct CustomTextField: View {
    var pholder: String
    @State var isSecure: Bool?
    @State var isEmail: Bool?
    @State var isSearch: Bool?
    @State var image: String
    @Binding var text: String
    @FocusState var isEnabled: Bool
    
    var body: some View {
        if isSecure != nil {
            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color("accent"))
                .foregroundColor(.white)
                .frame(height: 50)
                .overlay {
                    HStack() {
                        Image(systemName: image)
                            .foregroundColor(Color("accent"))
                            .padding(10)
                        
                        SecureField(pholder, text: $text)
                            .keyboardType(.default)
                            .focused($isEnabled)
                            .textContentType(.password)

                        if (text.count != 0) {
                            Image(systemName: text.isValidPassword(password: text) ? "checkmark" : "xmark")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                }
        } else if isEmail != nil {
            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color("accent"))
                .foregroundColor(.white)
                .frame(height: 50)
                .overlay {
                    HStack() {
                        Image(systemName: image)
                            .foregroundColor(Color("accent"))
                            .padding(10)
                        
                        TextField(pholder, text: $text)
                            .keyboardType(.emailAddress)
                            .focused($isEnabled)
                            .textContentType(.emailAddress)
                            .disableAutocorrection(true)
                        
                        if (text.count != 0) {
                            Image(systemName: text.isValidMail(email: text) ? "checkmark" : "xmark")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                }
        } else if isSearch != nil {
            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color("accent"))
                .foregroundColor(.orange)
                .frame(height: 50)
                .overlay {
                    HStack() {
                        Image(systemName: image)
                            .foregroundColor(Color("accent"))
                            .padding(10)
                        
                        TextField(pholder, text: $text)
                            .keyboardType(.default)
                            .focused($isEnabled)
                    }
                }
        } else {
            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color("accent"))
                .foregroundColor(.white)
                .frame(height: 50)
                .overlay {
                    HStack() {
                        Image(systemName: image)
                            .foregroundColor(.black)
                            .padding(10)
                        
                        TextField(pholder, text: $text)
                            .keyboardType(.default)
                            .focused($isEnabled)
                            .disableAutocorrection(true)
                            .textContentType(.none)
                        
                        if (text.count != 0) {
                            Image(systemName: !text.isEmpty ? "checkmark" : "xmark")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                }
        }
        
    }
}

#Preview {
    LoginView()
}
