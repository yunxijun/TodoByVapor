//
//  SettingsDetailsView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/8.
//

import SwiftUI
import Foundation

struct SettingsDetailsView: View {
    var setting: Setting
    @State private var fullText: String = ""
    @FocusState var isFocused:Bool
    var body: some View {
        VStack {
            TextEditor(text: $fullText)
                .navigationTitle(setting.name)
                .opacity(1)
                .font(.custom("System 12", size: 15))
                .lineSpacing(5)
                .padding(.vertical)
                .padding(.horizontal, 20)
                .focused($isFocused)
                .onChange(of: isFocused) { newValue in
                    if isFocused == false {
                        HttpClient.default.updateContentFromSettingID(from: setting.id, content: fullText, name: nil)
                    }
                }
                .onChange(of: fullText) { newValue in
                    print("\(fullText)")
                }
                .onAppear() {
                    HttpClient.default.getSettingFromID(from: setting.id) { settings in
                        fullText = settings.first?.content ?? "Hello world"
                    }
                }
        }.background(Color.clear)
    }
}

struct SettingsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDetailsView(setting: Setting.init(name: "Profile"))
    }
}

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
        }

    }
}
