//
//  SettingView.swift
//  SchulteGrid
//
//  Created by yx h on 27/3/2026.
//

import SwiftUI

struct SettingView: View {
    @Binding var gridSize: Int
    @Binding var highlightTapped: Bool
    @Binding var isDarkMode: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.largeTitle.bold())
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Grid Size")
                    .font(.headline)
                
                Picker("Grid Size", selection: $gridSize) {
                    Text("3 x 3").tag(3)
                    Text("4 x 4").tag(4)
                    Text("5 x 5").tag(5)
                    Text("6 x 6").tag(6)
                }
                .pickerStyle(.segmented)
            }
            
            Toggle("Highlight tapped numbers", isOn: $highlightTapped)
            Toggle("Dark mode", isOn: $isDarkMode)
            
            Spacer()
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

//#Preview {
//    ContentView()
//}
