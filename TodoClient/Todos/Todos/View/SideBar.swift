//
//  SideBar.swift
//  Todos
//
//  Created by devin_sun on 2022/8/8.
//

import SwiftUI

class RenameData: ObservableObject {
    @Published var renameString = "ok"
}

struct SideBar: View {
    @EnvironmentObject var settingsCategories: CategoriesModel
    @EnvironmentObject var searchSettingsModel: SearchSettingModel
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var imageModel: ImageModel
    @State private var selectedCategory: Category?
    @State private var isRename: Bool = false
    @State private var isDelete: Bool = false
    @State private var isAdd: Bool = false
    @State private var isShowRename: Bool = false
    @State private var search_term: String = ""
    var body: some View {
        VStack {
            List() {
                Text("")
            }.frame(height: 30).padding(.top)
            .searchable(text: $search_term, placement: .sidebar, prompt: "Search setting name")
            .onChange(of: search_term) { newValue in
                if search_term != "" {
                    searchSettingsModel.isSearched = true
                    print(search_term)
                } else {
                    searchSettingsModel.update()
                    searchSettingsModel.isSearched = false
                }
            }
            List(settingsCategories.categories) { category in
                NavigationLink(
                    destination: SettingsListView(settingsCategory: category, settingsModel: SettingsModel(with: category.id), serachQuery: $search_term, isDismissSearch: !searchSettingsModel.isSearched),
                     tag: category,
                     selection: $selectedCategory,
                     label: {
                         HStack {
                             Image(systemName: "alarm.fill")
                                 .symbolRenderingMode(.monochrome)
                                 .foregroundStyle(Color.indigo).font(.title2)
                             Text(category.name)
                                 .font(.title3)
                         }
                     }
                )
                .onAppear() {
                    if selectedCategory != nil {
                        return
                    }
                    if settingsCategories.categories.isEmpty == false {
                        selectedCategory = settingsCategories.categories[0]
                    }
                }
                .frame(height: 30.0)
            }
            .sheet(isPresented: $isRename, content: {
                RenameCategoryView( selectedCategory:$selectedCategory, name: selectedCategory!.name, isPresented: $isRename)

            })
            .sheet(isPresented: $isDelete, content: {
                DeleteCategoryView(selectedCategory: $selectedCategory, isPresented: $isDelete)
            })
            .sheet(isPresented: $isAdd, content: {
                AddCategoryView(selectedCategory: $selectedCategory, name: "", isPresented: $isAdd)
            })
            .contextMenu {
                if selectedCategory != nil {
                    Button {
                        isRename = true
                    } label: {
                        Label("Rename", systemImage: "globe")
                    }
                    Button {
                        isDelete = true
                    } label: {
                        Label("Delete", systemImage: "globe")
                    }
                }
                Button {
                    isAdd = true
                } label: {
                    Label("New Category", systemImage: "globe")
                }
            }
            .listStyle(SidebarListStyle())
            CircleImage(isLoginIned: .constant(userModel.isLogin))
        }
 
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar().environmentObject(CategoriesModel())
    }
}
