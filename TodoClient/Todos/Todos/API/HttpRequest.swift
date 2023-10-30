//
//  HttpRequest.swift
//  Todos
//
//  Created by devin_sun on 2022/8/9.
//

import Foundation

//struct DTOCategory:Identifiable, Hashable, Codable {
//    var id: UUID
//    var name: String
//    var settings: [DTOSettingContent]?
//}
//
//struct DTOSettingContent:Identifiable, Hashable, Codable {
//    var id: UUID
//    var name: String
//    var content: String
//    var todo: CategoryID
//}
//

struct DTOContent: Codable {
    var name: String?
    var content: String?
}

struct DTOSetting: Codable {
    var name: String?
    var content: String?
    var todo: CategoryID
}

struct DTOCategory: Codable {
    var name: String
}

struct DTOCreateUser: Codable {
    var name: String
    var password: String
    var confirmPassword: String
}

struct DTOPatchUser: Codable {
    var name: String?
    var image: String?
    var password: String?
}



class HttpClient {
    class var `default`: HttpClient {
        get {
            HttpClient()
        }
    }
    
    static let baseUrl: URL = URL(string: "http://127.0.0.1:8080")!
   
    static let baseCategoryUrl: URL = URL(string: "http://127.0.0.1:8080/todos")!
    static let baseSettingUrl: URL = URL(string: "http://127.0.0.1:8080/settings")!
    static let baseUserUrl: URL = URL(string: "http://127.0.0.1:8080/users")!
    
    // user api
    
    func registerUser(name: String, password: String, confirmPassword: String, successBlock: ((UserToken) -> (Void))? = nil, failBlock: ((Error) -> (Void))? = nil) {
        var request = URLRequest(url: HttpClient.baseUserUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let category = DTOCreateUser(name: name, password: password, confirmPassword: confirmPassword)
        guard let data = try? encoder.encode(category) else {
            return
        }
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let userToken = try decoder.decode(UserToken.self, from: data)
                    UserDefaults.standard.set(userToken.value, forKey: "name")
                    UserDefaults.standard.set(name, forKey: "recentUser")
                    successBlock?(userToken)
                    print(userToken)
                } catch {
                    failBlock?(error)
                    print(error)
                }
            }
        }.resume()
    }
    
    func loginUser(with name: String, password: String, successBlock: ((UserToken) -> (Void))? = nil, failBlock: ((Error) -> (Void))? = nil) {
        let targetString = "\(HttpClient.baseUrl)/loginWithPassword"
        guard let url = URL(string: targetString) else {
            return
        }
        var request = URLRequest(url: url)
        let loginString = "\(name):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            return
        }
        let base64String = loginData.base64EncodedString()
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let userToken = try decoder.decode(UserToken.self, from: data)
                    UserDefaults.standard.setValue(userToken.value, forKey: name)
                    UserDefaults.standard.setValue(name, forKey: "RECENTUSER")
                    UserDefaults.standard.setValue(userToken.user?.id.uuidString, forKey: "USERID")
                    successBlock?(userToken)
                    print(userToken)
                } catch {
                    failBlock?(error)
                    print(error)
                }
            }
        }.resume()
    }
    
    func loginUser(with name: String, token: String, successBlock: ((UserToken) -> (Void))? = nil) {
        var request = URLRequest(url: HttpClient.baseUserUrl)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let userToken = try decoder.decode(UserToken.self, from: data)
                    UserDefaults.standard.set(userToken.value, forKey: "name")
                    UserDefaults.standard.set(name, forKey: "recentUser")
                    UserDefaults.standard.setValue(userToken.user?.id.uuidString, forKey: "USERID")
                    successBlock?(userToken)
                    print(userToken)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func modifyUser(name: String, imageUrl:URL, successBlock: ((User) -> (Void))? = nil, failBlock: ((Error) -> (Void))? = nil) {
        let baseString = HttpClient.baseUserUrl.absoluteString
        let targetString = "\(baseString)/\(name)"
        guard let url = URL(string: targetString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let patchUser = DTOPatchUser(image: imageUrl.absoluteString)
        guard let data = try? encoder.encode(patchUser) else {
            return
        }
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(User.self, from: data)
                    successBlock?(user)
                } catch {
                    failBlock?(error)
                    print(error)
                }
            }
        }.resume()
    }
    
    func getUser(with name: String? = nil, token: String, successBlock: (([User]) -> (Void))? = nil) {
        let baseString = HttpClient.baseUserUrl.absoluteString
        let targetString = "\(baseString)/\(name ?? "")"
        guard let url = URL(string: targetString) else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(User.self, from: data)
                    successBlock?([user])
                    print([user])
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
//    category api: getAll
    func getAllCategory(with useId:String, token:String, successBlock: (([Category]) -> (Void))? = nil){
        let baseString = HttpClient.baseCategoryUrl.absoluteString
        let targetString = "\(baseString)/todo/\(useId)"
        guard let url = URL(string: targetString) else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let categories = try decoder.decode([Category].self, from: data)
                    successBlock?(categories)
                    print(categories)
//                    let dict = try JSONSerialization.jsonObject(with: data)
//                    print(dict)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func deleteCategory(with id: UUID, successBlock: (() -> (Void))? = nil) {
        let baseString = HttpClient.baseCategoryUrl.absoluteString
        let targetString = "\(baseString)/\(id.uuidString)"
        guard let url = URL(string: targetString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else {
                successBlock?()
            }
        }.resume()
    }
    
    
    func createCategory(with title: String, successBlock: ((Category) -> (Void))? = nil) {
        guard let recentUserName = UserDefaults.standard.value(forKey: "RECENTUSER") as? String else {
            return
        }
        guard let token = UserDefaults.standard.value(forKey: recentUserName) as? String else {
            return
        }
        guard let userID = UserDefaults.standard.value(forKey: "USERID") as? String else {
            return
        }
        let baseString = HttpClient.baseCategoryUrl.absoluteString
        let targetString = "\(baseString)"
        guard let url = URL(string: targetString) else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        guard let uuid = UUID(uuidString: userID) else {
            return
        }
        let category = Category(name: title, user: UserID(id: uuid))
        guard let data = try? encoder.encode(category) else {
            return
        }
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let categories = try decoder.decode(Category.self, from: data)
                    successBlock?(categories)
                    print(categories)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func modifyCategory(with title: String, for id:UUID, successBlock: ((Category) -> (Void))? = nil) {
        let baseString = HttpClient.baseCategoryUrl.absoluteString
        let targetString = "\(baseString)/\(id.uuidString)"
        guard let url = URL(string: targetString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let DTOCategory = DTOCategory(name: title)
        guard let data = try? encoder.encode(DTOCategory) else {
            return
        }
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let category = try decoder.decode(Category.self, from: data)
                    successBlock?(category)
                    print(category)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getCategorySetting(from id:UUID, successBlock: (([Setting]) -> (Void))? = nil){
        let baseString = HttpClient.baseSettingUrl.absoluteString
        let targetString = "\(baseString)/\(id.uuidString)"
        guard let url = URL(string: targetString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let settings = try decoder.decode([Setting].self, from: data)
                    successBlock?(settings)
                    print(settings)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getSettingFromID(from id:UUID, successBlock: (([Setting]) -> (Void))? = nil){
        let baseString = HttpClient.baseSettingUrl.absoluteString
        let targetString = "\(baseString)?setting_id=\(id.uuidString)"
        guard let url = URL(string: targetString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let settings = try decoder.decode([Setting].self, from: data)
                    successBlock?(settings)
                    print(settings)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func createSetting(from parentId: UUID, name: String, successBlock: ((Setting) -> (Void))? = nil) {
        var request = URLRequest(url: HttpClient.baseSettingUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let setting = DTOSetting(name: name, content: "", todo: CategoryID(id: parentId))
        guard let data = try? encoder.encode(setting) else {
            return
        }
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let settings = try decoder.decode(Setting.self, from: data)
                    successBlock?(settings)
                    print(settings)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func deleteSetting(with id: UUID, successBlock: (() -> (Void))? = nil) {
        let baseString = HttpClient.baseSettingUrl.absoluteString
        let targetString = "\(baseString)/\(id.uuidString)"
        guard let url = URL(string: targetString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else {
                successBlock?()
            }
        }.resume()
    }
    
    func updateContentFromSettingID(from id: UUID, content: String?, name: String?, successBlock: (() -> (Void))? = nil) {
        let baseString = HttpClient.baseSettingUrl.absoluteString
        let targetString = "\(baseString)/\(id.uuidString)"
        guard let url = URL(string: targetString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let category = DTOContent(name: name, content: content)
        guard let data = try? encoder.encode(category) else {
            return
        }
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let settingContent = try decoder.decode(Setting.self, from: data)
                    successBlock?()
                    print(settingContent)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getAllSettings(successBlock: (([Setting]) -> (Void))? = nil) {
        let baseString = HttpClient.baseSettingUrl.absoluteString
        guard let url = URL(string: baseString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                let decoder = JSONDecoder()
                do {
                    let settings = try decoder.decode([Setting].self, from: data)
                    successBlock?(settings)
                    print(settings)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
    



