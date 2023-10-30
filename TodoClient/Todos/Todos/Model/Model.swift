//
//  Model.swift
//  SplitViewWithSwiftUI
//
//  Created by devin_sun on 2022/8/3.
//

import Foundation
import Cocoa
import SwiftUI

struct User: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var image_name:String?
    var todo: [Category]?
    var tokens: [UserToken]?
}

struct UserToken: Identifiable, Hashable, Codable {
    var id = UUID()
    var value: String
    var user: UserID?
}

struct Category: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var settings: [Setting]?
    var user: UserID?
}

struct Setting: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var content: String = ""
    var todo: CategoryID?
}

struct CategoryID: Identifiable, Hashable, Codable{
    var id: UUID
}

struct UserID: Identifiable, Hashable, Codable{
    var id: UUID
}

struct ImageEntity: Identifiable, Hashable, Codable {
    var id = UUID()
    var imageURL: URL
}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(name))
    }

    static func loadImage(name: String) -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "jpg"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

class CategoriesModel: ObservableObject {
    @Published var isSearched = false
    @Published var categories: [Category] = [Category]()
    
    init() {
        guard let recentUserName = UserDefaults.standard.value(forKey: "RECENTUSER") as? String else {
            return
        }
        guard let token = UserDefaults.standard.value(forKey: recentUserName) as? String else {
            return
        }
        
        guard let userID = UserDefaults.standard.value(forKey: "USERID") as? String else {
            return
        }
        
        HttpClient.default.getAllCategory(with: userID, token: token) { categoryArray in
            DispatchQueue.main.async {
                self.categories = categoryArray
            }
        }
    }
    
    func updateAllCategory() {
        guard let recentUserName = UserDefaults.standard.value(forKey: "RECENTUSER") as? String else {
            return
        }
        guard let token = UserDefaults.standard.value(forKey: recentUserName) as? String else {
            return
        }
        guard let userID = UserDefaults.standard.value(forKey: "USERID") as? String else {
            return
        }
        HttpClient.default.getAllCategory(with: userID, token: token) { categoryArray in
            DispatchQueue.main.async {
                self.categories = categoryArray
            }
        }
    }
}

class SettingsModel: ObservableObject {
    @Published var settings = [Setting]()
    
    init(with category: UUID) {
        HttpClient.default.getCategorySetting(from: category) { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    func update(with category: UUID) {
        HttpClient.default.getCategorySetting(from: category) { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
}

class SearchSettingModel: ObservableObject {
    @Published var isSearched = false
    @Published var settings = [Setting]()
    
    init() {
        HttpClient.default.getAllSettings(successBlock: { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        })
    }
    
    func update() {
        HttpClient.default.getAllSettings(successBlock: { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        })
//        HttpClient.default.getAllSettings(successBlock: { settings in
//            DispatchQueue.main.async {
//                self.settings = settings
//            }
//        })
    }
}

class UserModel: ObservableObject {
    
    @Published var currentUser: [User] = [User]()
    @Published var isLogin = false
    init() {
        guard let recentUserName = UserDefaults.standard.value(forKey: "RECENTUSER") as? String else {
            return
        }
        guard let token = UserDefaults.standard.value(forKey: recentUserName) as? String else {
            return
        }
        guard let userID = UserDefaults.standard.value(forKey: "USERID") as? String else {
            return
        }
        HttpClient.default.getUser(with: userID, token: token) { user in
            DispatchQueue.main.async {
                self.currentUser = user
                self.isLogin = true
            }
        }
    }
    
    func update() {
        guard let recentUserName = UserDefaults.standard.value(forKey: "RECENTUSER") as? String else {
            return
        }
        guard let token = UserDefaults.standard.value(forKey: recentUserName) as? String else {
            return
        }
        guard let userID = UserDefaults.standard.value(forKey: "USERID") as? String else {
            return
        }
        HttpClient.default.getUser(with: userID, token: token) { user in
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.isLogin = true
            }

        }
    }
}

class ImageModel: ObservableObject {

    @Published var currentImageUrl: URL = URL(string: "https://cn.docs.vapor.codes/4.0/assets/logo.png")!
    @Published var imageCollections: [ImageEntity] = [
        ImageEntity(imageURL: URL.init(string: "https://cn.docs.vapor.codes/4.0/assets/logo.png")!),ImageEntity(imageURL: URL.init(string: "https://img0.baidu.com/it/u=4065107391,2142799144&fm=253&fmt=auto&app=138&f=JPEG?w=527&h=500")!),ImageEntity(imageURL: URL.init(string: "https://img2.baidu.com/it/u=775842536,3632317727&fm=253&fmt=auto&app=138&f=JPEG?w=504&h=500")!),ImageEntity(imageURL: URL.init(string: "https://img2.baidu.com/it/u=3141985087,2955906521&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500")!),ImageEntity(imageURL: URL.init(string: "https://img1.baidu.com/it/u=2579969943,3922736892&fm=253&fmt=auto&app=138&f=JPEG?w=512&h=500")!),ImageEntity(imageURL: URL.init(string: "https://img2.baidu.com/it/u=3107444060,2465042788&fm=253&fmt=auto&app=120&f=JPEG?w=690&h=690")!),ImageEntity(imageURL: URL.init(string: "https://img1.baidu.com/it/u=2755933383,62081292&fm=253&fmt=auto&app=138&f=JPEG?w=503&h=500")!), ImageEntity(imageURL: URL.init(string: "http://127.0.0.1:8080/charleyrivers.jpg")!)
    ]
    
    init() {
        guard let recentUserName = UserDefaults.standard.value(forKey: "RECENTUSER") as? String else {
            return
        }
        guard let token = UserDefaults.standard.value(forKey: recentUserName) as? String else {
            return
        }
        guard let userID = UserDefaults.standard.value(forKey: "USERID") as? String else {
            return
        }
        HttpClient.default.getUser(with: userID, token: token) { user in
            DispatchQueue.main.async {
                guard let image_name = user.first?.image_name else {
                    return
                }
                guard let url = URL(string: image_name) else {
                    return
                }
                self.currentImageUrl = url
            }
        }
    }
    
    func savePreferImageURL(url: URL) {
        guard let recentUserName = UserDefaults.standard.value(forKey: "RECENTUSER") as? String else {
            return
        }
        guard let _ = UserDefaults.standard.value(forKey: recentUserName) as? String else {
            return
        }
        guard let userID = UserDefaults.standard.value(forKey: "USERID") as? String else {
            return
        }
        HttpClient.default.modifyUser(name: userID, imageUrl: url) { user in
            guard let image_name = user.image_name else {
                return
            }
            guard let url = URL(string: image_name) else {
                return
            }
            DispatchQueue.main.async {
                self.currentImageUrl = url
            }
        }
    }
}

