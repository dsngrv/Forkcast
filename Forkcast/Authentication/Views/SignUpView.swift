//
//  SignUpView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 27.05.2024.
//

import FirebaseAuth
import SwiftUI

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    VStack() {
                        (Text("Create An Account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("accent"))
                         +
                         Text("\nFORKCAST ")
                            .foregroundColor(.black)
                            .font(.title)
                            .fontWeight(.black)
                        )
                        .lineSpacing(10)
                    }
                    
                    CustomTextField(pholder: "Email", isEmail: true, image: "mail", text: $email)
                        .padding(.top, 25)
                    
                    CustomTextField(pholder: "Name", image: "person", text: $name)
                        .padding(.top, 10)
                    
                    CustomTextField(pholder: "Password", isSecure: true, image: "lock", text: $password)
                        .padding(.top, 10)
                }
                .padding(.leading ,50)
                .padding(.trailing, 50)
                .padding(.vertical, 25)
                
                Button {
                    Task {
                        try await viewModel.createUser(withEmail: email, password: password, name: name)
                    }
                } label: {
                    Text("Create Account")
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 50)
                .background(.black)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.8)
                .cornerRadius(10)
                
                NavigationLink {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("Already have an account?")
                        Text("Sign In")
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

extension SignUpView: AuthFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && !password.isEmpty
        && !name.isEmpty
    }
}

#Preview {
    SignUpView()
}
