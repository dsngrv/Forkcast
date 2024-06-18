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
                    
                    CustomTextField(pholder: "Email", isEmail: true, image: "mail", text: $email)
                        .padding(.top, 25)
                    
                    CustomTextField(pholder: "Password", isSecure: true, image: "lock", text: $password)
                        .padding(.top, 10)
                }
                .padding(.leading ,50)
                .padding(.trailing, 50)
                .padding(.vertical, 25)
                
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 50)
                .background(.black)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.8)
                .cornerRadius(10)
                
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color("accent"))
                    .padding()
                }
                
//                NavigationLink {
//                    ContentView()
//                        .navigationBarBackButtonHidden(true)
//                } label: {
//                    HStack {
//                        Text("I'm just looking 🧐")
//                            .fontWeight(.bold)
//                    }
//                    .foregroundColor(.blue)
//                    .padding()
//                }
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
