//
//  AcountImage.swift
//  Todos
//
//  Created by devin_sun on 2022/8/12.
//

import SwiftUI
import Foundation

struct CircleImage: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var settingsCategories: CategoriesModel
    @EnvironmentObject var imageModel: ImageModel
    @State private var isClickMenu = false
    @State var isPresent = false
    @Binding var isLoginIned: Bool
    @State var isRegisting = false
    @State var isLogining = false
    @State var registerSuccess: Bool = false
    @State var loginSuccess: Bool = false
    @State var isLookProfile: Bool = false
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Button {
                isLookProfile = true
            } label: {
                AsyncImage(url: imageModel.currentImageUrl) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }.frame(width: 50, height: 50).clipShape(Circle())
            }.buttonStyle(.plain)
            if isLoginIned {
                Text(userModel.currentUser.first?.name ?? "")
            } else {
                Text("Not login")
            }
            Spacer()
            if isLoginIned {
                Menu("Sign out") {
                    Button {
                    } label: {
                        Label("Log out", systemImage: "globe")
                    }
                } primaryAction: {
                    print("e")
                }.frame(maxWidth: 100)
            } else {
                Menu("Sign in") {
                    Button {
                        isLogining = false
                        isRegisting = true
                        isPresent = true
                    } label: {
                        Label("Sign up", systemImage: "globe")
                    }
                } primaryAction: {
                    isRegisting = false
                    isLogining = true
                    isPresent = true
                }.frame(maxWidth: 100)
            }

        }.padding()
            .sheet(isPresented: $isPresent) {
                SignInOutView(registerSuccess: $registerSuccess, loginSuccess: $loginSuccess, isLogining: $isLogining, isRegisting: $isRegisting, isPresent: $isPresent)
            }
        
            .sheet(isPresented: $isLookProfile) {
                ProfileView(isLookProfile: $isLookProfile, preferRemoteImage: imageModel.currentImageUrl)
            }
    }
    
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(isLoginIned: .constant(false))
    }
}

