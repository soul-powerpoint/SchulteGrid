//
//  SettingView.swift
//  SchulteGrid
//
//  Created by yx h on 27/3/2026.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct SettingView: View {
    @Binding var gridSize: Int
    @Binding var highlightTapped: Bool
    @Binding var appTheme: AppTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.largeTitle.bold())
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Grid Size").font(.headline)
                
                Picker("Grid Size", selection: $gridSize) {
                    Text("3 x 3").tag(3)
                    Text("4 x 4").tag(4)
                    Text("5 x 5").tag(5)
                    Text("6 x 6").tag(6)
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Theme").font(.headline)
                
                Picker("Grid Size", selection: $appTheme) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Text(theme.rawValue).tag(theme)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Toggle("Highlight tapped numbers", isOn: $highlightTapped)
            
            Spacer()
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

//#Preview {
//    ContentView()
//}
