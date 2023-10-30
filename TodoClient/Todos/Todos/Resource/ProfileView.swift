//
//  ProfileView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/14.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var imageModel: ImageModel
    @Binding var isLookProfile: Bool
    @State var preferRemoteImage: URL
    var body: some View {
        VStack() {
            HStack(spacing: 30) {
                VStack {
                    Text("Profile").font(.title3)
                    AsyncImage(url: preferRemoteImage) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }.frame(width: 130, height: 130).clipShape(Circle())
                }
                Button {
                    print("")
                } label: {
                    Text("upload")
                }

            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(imageModel.imageCollections) { imageEntity in
                        Button {
                            preferRemoteImage = imageEntity.imageURL
                        } label: {
                            VStack(alignment: .leading) {
                                AsyncImage(url: imageEntity.imageURL) { image in
                                    image                        .renderingMode(.original)
                                        .resizable()
//                                        .frame(width: 155, height: 155)
                                        .cornerRadius(5)
                                } placeholder: {
                                    Color.gray
                                }.frame(width: 155, height: 155).clipShape(Rectangle())
                            }
                            .padding(.leading, 15)
                        }.buttonStyle(.plain)
                        
                    }
                }
            }.frame(height: 200).padding()
            Spacer()
            HStack(spacing: 30) {
                Button {
                    isLookProfile = false
                } label: {
                    Text("Cancel")
                }
                Button {
                    imageModel.savePreferImageURL(url: preferRemoteImage)
                    isLookProfile = false
                } label: {
                    Text("Save")
                }
            }.padding()

        }.frame(width: 500, height: 500).padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLookProfile: .constant(false), preferRemoteImage: URL.init(string: "https://cn.docs.vapor.codes/4.0/assets/logo.png")!)
    }
}
