//
//  ContentView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/8.
//

import SwiftUI

struct ContentView: View {
    var userModel = UserModel()
    var settingsCategories = CategoriesModel()
    var searchSettingsModel = SearchSettingModel()
    var imageModel = ImageModel()
    @Environment(\.isSearching) private var isSearching
    var body: some View {
        NavigationView {
            SideBar()
            EmptyView()
            Text("Hello, world!")
            .padding()
        }
        .environmentObject(settingsCategories)
        .environmentObject(searchSettingsModel)
        .environmentObject(userModel)
        .environmentObject(imageModel)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                Button {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(
                            #selector(NSSplitViewController.toggleSidebar(_:)), with: nil
                    )
                } label: {
                    Label("Toggle sidebar", systemImage: "sidebar.left")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
