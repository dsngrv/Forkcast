//
//  LoginView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 27.05.2024.
//

import FirebaseAuth
import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    VStack() {
                        Image("forkrain")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(Color("accent"))
                            .frame(width: 300, height: 300)
                        
                        Text("FORKCAST")
                            .foregroundColor(Color("accent"))
                            .font(.title)
                            .fontWeight(.black)
                        
                    }
                    
                    CustomTextField(pholder: "Email".localized, fieldType: .email, image: "mail", text: $email)
                        .padding(.top, 25)
                    
                    CustomTextField(pholder: "Password".localized, fieldType: .secure,  image: "lock", text: $password)
                        .padding(.top, 25)
                }
                .padding(.leading ,50)
                .padding(.trailing, 50)
                .padding(.vertical, 25)
                
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    Text("Sign In".localized)
                        .foregroundColor(Color("text"))
                }
                .frame(width: 300, height: 50)
                .background(Color("rectAccent"))
                .shadow(radius: 10)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.8)
                .cornerRadius(10)
                
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("Don't have an account?".localized)
                        Text("Sign Up".localized)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color("accent"))
                    .padding()
                }

            }
            .background(Color("background"))
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension LoginView: AuthFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && !password.isEmpty
    }
}

#Preview {
    LoginView()
}
