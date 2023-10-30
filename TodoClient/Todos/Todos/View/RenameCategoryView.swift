//
//  RenameView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/8.
//

import SwiftUI

struct RenameCategoryView: View {
    @EnvironmentObject var settingsCategories: CategoriesModel
    @Binding var selectedCategory: Category?
    @State var name: String
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("New name")
                    .lineLimit(8)
                TextField("Name's placeholder", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 50)
            }.padding()

            HStack(alignment: .top, spacing: 100.0) {
                Button {
                    self.isPresented = false
                } label: {
                    Text("Cancel")
                }.padding(.bottom, 16.0)
                
                Button {
                    renameSelectCatergory(name)
                    self.isPresented = false
                } label: {
                    Text("Confirm")
                }.padding(.bottom, 16.0)
            
            }
        }
    }
    
    func renameSelectCatergory(_ name: String) {
        if let selectedCategory = selectedCategory {
            for (index, item) in settingsCategories.categories.enumerated() {
                if item.id == selectedCategory.id {
                    HttpClient.default.modifyCategory(with: name, for: selectedCategory.id) { _ in
                        DispatchQueue.main.async {
                            settingsCategories.categories[index].name = name
                        }
                    }
                }
            }
            return
        }
    }
}

struct RenameCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        RenameCategoryView(selectedCategory: .constant(Category.init(name: "profile")), name: "profile", isPresented: .constant(false))
    }
}
