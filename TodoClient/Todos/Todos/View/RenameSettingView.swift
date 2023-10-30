//
//  RenameSetting.swift
//  Todos
//
//  Created by devin_sun on 2022/8/11.
//

import SwiftUI

struct RenameSettingView: View {
    @StateObject var settingsModel: SettingsModel
    @Binding var selectedSetting: Setting?
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
                    renameSelectSetting(name)
                    self.isPresented = false
                } label: {
                    Text("Confirm")
                }.padding(.bottom, 16.0)
            
            }
        }
    }
    
    func renameSelectSetting(_ name: String) {
        if let selectedSetting = selectedSetting {
            HttpClient.default.updateContentFromSettingID(from: selectedSetting.id, content: nil, name: name) {
                for (index, item) in settingsModel.settings.enumerated() {
                    if item.id == selectedSetting.id {
                        DispatchQueue.main.async {
                            settingsModel.settings[index].name = name
                        }
                        return
                    }
                }
            }
        }
    }
}

struct RenameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        RenameSettingView(settingsModel: SettingsModel(with: UUID()), selectedSetting: .constant(Setting(name: "test")), name: "test2", isPresented: .constant(false))
    }
}
