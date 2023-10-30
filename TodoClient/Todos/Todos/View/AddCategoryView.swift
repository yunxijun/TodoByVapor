//
//  AddView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/8.
//

import SwiftUI

struct AddCategoryView: View {
    @EnvironmentObject var settingsCategories: CategoriesModel
    @Binding var selectedCategory: Category?
    @State var name: String
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("New Category")
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
                    addSelectCatergory(name)
                    self.isPresented = false
                } label: {
                    Text("Confirm")
                }.padding(.bottom, 16.0)
            
            }
        }
    }
    
    func addSelectCatergory(_ name: String) {
        HttpClient.default.createCategory(with: name) { category in
            DispatchQueue.main.async {
                settingsCategories.categories.append(category)
                selectedCategory = category
            }
        }
        
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(selectedCategory: .constant(nil), name: "test", isPresented: .constant(false))
    }
}
