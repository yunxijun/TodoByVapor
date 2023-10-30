//
//  RegisterResView.swift
//  Todos
//
//  Created by devin_sun on 2022/8/13.
//

import SwiftUI

struct RegisterResView: View {
    @Binding var isPresent: Bool
    var errorMessage: String =  ""
    var body: some View {
        VStack {
            Text(errorMessage).padding()
            Button {
                isPresent = false
                print("success")
            } label: {
                Text("ok, I konw")
            }

        }.padding().frame(minWidth: 300, minHeight: 150)

    }
}

struct RegisterResView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterResView(isPresent: .constant(false))
    }
}
