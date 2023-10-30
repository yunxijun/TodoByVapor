//
//  TodosApp.swift
//  Todos
//
//  Created by devin_sun on 2022/8/8.
//

import SwiftUI

@main
struct TodosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowToolbarStyle(UnifiedWindowToolbarStyle())
        .windowStyle(.titleBar)
    }
}
