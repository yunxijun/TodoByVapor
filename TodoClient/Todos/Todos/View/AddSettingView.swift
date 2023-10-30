//
//  AddSettingView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/10.
//

import SwiftUI

struct AddSettingView: View {
    @StateObject var settingsModel: SettingsModel
    @State var name: String
    @Binding var isPresented: Bool
    @Binding var selectedCategoryID: UUID
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("New Setting")
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
                    addSelectSetting(name)
                    self.isPresented = false
                } label: {
                    Text("Confirm")
                }.padding(.bottom, 16.0)
            
            }
        }
    }
    
    func addSelectSetting(_ name: String) {
        HttpClient.default.createSetting(from: selectedCategoryID, name: name) { setting in
            DispatchQueue.main.async {
                settingsModel.settings.append(setting)
            }
        }
    }
}

struct AddSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AddSettingView(settingsModel: SettingsModel(with: UUID()), name: "", isPresented: .constant(false), selectedCategoryID: .constant(UUID()))
    }
}
