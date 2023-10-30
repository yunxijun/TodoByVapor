//
//  SignInOutView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/13.
//

import SwiftUI

struct SignInOutView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var settingsCategories: CategoriesModel
    @State private var userName = ""
    @State private var userPassword = ""
    @State private var userConfirmPassword = ""
    @Binding var registerSuccess: Bool
    @Binding var loginSuccess: Bool
    @Binding var isLogining: Bool
    @Binding var isRegisting: Bool
    @Binding var isPresent: Bool
    @State var showErrorView = false
    @State var errorMessage = ""
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("User name")
                    Text("User password")
                    if isRegisting {
                        Text("Confirm password")
                    }
                }.padding()
                
                VStack {
                    TextField("username", text: $userName)
                    SecureField("password", text: $userPassword)
                    if isRegisting {
                        SecureField("confirm password", text: $userConfirmPassword)
                    }
                }.padding()
            }.padding()

            
            HStack(spacing: 50.0) {
        
                Button {
                    isPresent = false
                } label: {
                    Text("Cancel")
                }
                
                HStack(spacing: 50.0) {
                    if isLogining {
                        Button {
                            HttpClient.default.loginUser(with: userName, password: userPassword) { token in
                                userModel.update()
                                settingsCategories.updateAllCategory()
                                loginSuccess = true
                                isPresent = false
                            } failBlock: { error in
                                showErrorView = true
                                errorMessage = error.localizedDescription
                            }
                        } label: {
                            Text("Sign in")
                        }
                    }
                    if isRegisting {
                        Button {
                            HttpClient.default.registerUser(name: userName, password: userPassword, confirmPassword: userConfirmPassword) { token in
                                userModel.update()
                                settingsCategories.updateAllCategory()
                                registerSuccess = true
                                isPresent = false
                            } failBlock: { error in
                                showErrorView = true
                                errorMessage = error.localizedDescription
                            }
                        } label: {
                            Text("Sign up")
                        }
                    }
                }

            }.padding()
        }.frame(width: 500).padding()
            .sheet(isPresented: $showErrorView) {
                RegisterResView(isPresent: $showErrorView, errorMessage: errorMessage)
            }
    }

}

struct SignInOutView_Previews: PreviewProvider {
    static var previews: some View {
        SignInOutView(registerSuccess: .constant(false), loginSuccess: .constant(false), isLogining: .constant(false), isRegisting: .constant(false), isPresent: .constant(false))
    }
}
