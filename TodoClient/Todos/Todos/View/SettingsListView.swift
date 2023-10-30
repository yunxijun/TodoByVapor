//
//  SettingsListView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/8.
//

import SwiftUI

struct SettingsListView: View {
    var settingsCategory: Category
    @StateObject var settingsModel: SettingsModel
    @EnvironmentObject var searchSettingsModel: SearchSettingModel
    @State private var selectedSetting: Setting?
    @State private var isRename: Bool = false
    @State private var isDelete: Bool = false
    @State private var isAdd: Bool = false
    @Binding var serachQuery: String
    var isDismissSearch: Bool
    var filterSettings: [Setting] {
        if serachQuery == "" {
            return searchSettingsModel.settings
        } else {
            let filterResult = searchSettingsModel.settings.filter { setting in
                setting.name.contains(serachQuery)
            }
            return filterResult
        }
    }
//    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.isSearching) private var isSearching
    var body: some View {
        if isDismissSearch == false {
            if filterSettings.isEmpty {
                VStack {
                    Text("No Related Setting")
                    Image("Found_nothing").resizable().frame(width: 200, height: 200)
                }
            } else {
                List(filterSettings) { setting in
                    NavigationLink(destination: SettingsDetailsView(setting: setting),
                                   tag: setting,
                                   selection: $selectedSetting) {
                        HStack {
                            Image(systemName: "envelope.badge")                 .symbolRenderingMode(.monochrome)
                                .foregroundStyle(Color.indigo).font(.title3)
                            Text(setting.name == "" ? "nothing find": setting.name)
                        }
                    }
                                   .frame(height: 40.0)
                }

            }
        } else {
            List(settingsModel.settings) { setting in
                NavigationLink(destination: SettingsDetailsView(setting: setting),
                               tag: setting,
                               selection: $selectedSetting) {
                    HStack {
                        Image(systemName: "envelope.badge")                 .symbolRenderingMode(.monochrome)
                            .foregroundStyle(Color.indigo).font(.title3)
                        Text(setting.name)
                    }
                }
                               .frame(height: 40.0)          .onAppear() {
                                   if settingsModel.settings.isEmpty == false {
                                       selectedSetting = settingsModel.settings[0]
                                   }
                               }
            }
            .sheet(isPresented: $isRename, content: {
                RenameSettingView(settingsModel: settingsModel, selectedSetting: $selectedSetting, name: selectedSetting!.name, isPresented: $isRename)

            })
            .sheet(isPresented: $isDelete, content: {
                DeleteSettingView(settingsModel: settingsModel, selectedSetting: $selectedSetting, isPresented: $isDelete)
            })
            
            .sheet(isPresented: $isAdd, content: {
                AddSettingView(settingsModel: settingsModel, name: "", isPresented: $isAdd, selectedCategoryID: .constant(settingsCategory.id))
            })
            
            .contextMenu {
                if selectedSetting != nil {
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
                    Label("New Setting", systemImage: "globe")
                }
            }
            .navigationTitle(settingsCategory.name)
            .listStyle(.sidebar)
//            .listRowBackground(Color.green)
        }
    }
}

struct SettingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsListView(settingsCategory: Category(name: "Profile"), settingsModel: SettingsModel(with: UUID()), serachQuery: .constant(""), isDismissSearch: false).environmentObject(SearchSettingModel())
    }
}
