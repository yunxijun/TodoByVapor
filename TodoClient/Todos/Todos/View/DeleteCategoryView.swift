//
//  DeleteView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/8.
//

import SwiftUI

struct DeleteCategoryView: View {
    @EnvironmentObject var settingsCategories: CategoriesModel
    @Binding var selectedCategory: Category?
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            Text("Are you sure to delete this category?").padding()
            HStack(spacing: 50.0) {
                Button {
                    self.isPresented = false
                } label: {
                    Text("NO")
                }
                Button {
                    deleteSelectCategory()
                    self.isPresented = false
                } label: {
                    Text("YES")
                }
            }.padding()
        }.padding()
    }
    
    func deleteSelectCategory() {
        defer {
            if settingsCategories.categories.count >= 0 {
                selectedCategory = settingsCategories.categories[0]
            } else {
                selectedCategory = nil
            }
        }
        if let selectedCategory = selectedCategory {
            for (index, item) in settingsCategories.categories.enumerated() {
                if item.id == selectedCategory.id {
                    HttpClient.default.deleteCategory(with: selectedCategory.id) {
                        DispatchQueue.main.async {
                            settingsCategories.categories.remove(at: index)
                        }
                    }
                    return
                }
            }
        }
    }
}

struct DeleteCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteCategoryView(selectedCategory: .constant(Category.init(name: "profile")), isPresented: .constant(false))
    }
}
