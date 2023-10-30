//
//  DeleteSettingView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/11.
//

import SwiftUI

struct DeleteSettingView: View {
    @StateObject var settingsModel: SettingsModel
    @Binding var selectedSetting: Setting?
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            Text("Are you sure to delete this category?").padding()
            HStack(spacing: 50.0) {
                Button {
                    isPresented = false
                } label: {
                    Text("NO")
                }
                Button {
                    isPresented = false
                    deleteSelectSetting()
                } label: {
                    Text("YES")
                }
            }.padding()
        }.padding()
    }
    
    func deleteSelectSetting() {
        if let selectedSetting = selectedSetting {
            for (index, item) in settingsModel.settings.enumerated() {
                if item.id == selectedSetting.id {
                    HttpClient.default.deleteSetting(with: selectedSetting.id) {
                        DispatchQueue.main.async {
                            settingsModel.settings.remove(at: index)
                        }
                    }
                    return
                }
            }
            return
        }
    }
}

struct DeleteSettingView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteSettingView(settingsModel: SettingsModel(with: UUID()), selectedSetting: .constant(Setting(name: "test")), isPresented: .constant(false))
    }
}
