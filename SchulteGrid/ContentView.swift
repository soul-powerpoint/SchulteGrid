//
//  ContentView.swift
//  SchulteGrid
//
//  Created by yx h on 26/3/2026.
//

import SwiftUI

enum SidebarItem: String, CaseIterable {
    case game = "Game"
    case settings = "Settings"
}

struct ContentView: View {
    @State private var selectedTab: SidebarItem = .game
    @State private var gridSize = 5
    @State private var numbers: [Int] = []
    @State private var nextTarget = 1
    @State private var isFinished = false
    @State private var startTime: Date? = nil
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer? = nil
    @State private var highlightTapped = true
    @State private var appTheme: AppTheme = .system
    @State private var wrongTap: Int? = nil
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: gridSize)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            gameView
                .tabItem { Label("Game", systemImage: "gamecontroller") }
                .tag(SidebarItem.game)
                
            SettingView(gridSize: $gridSize, highlightTapped: $highlightTapped, appTheme: $appTheme)
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(SidebarItem.settings)
        }
        .onChange(of: appTheme) {
            switch appTheme {
            case .light:
                NSApp.appearance = NSAppearance(named: .aqua)
            case .dark:
                NSApp.appearance = NSAppearance(named: .darkAqua)
            case .system:
                NSApp.appearance = nil
            }
        }
    }
    
    var gameView: some View {
        VStack(spacing: 20) {
            Text(isFinished ? "Done! 🎉" : "Tap \(nextTarget)").font(.title2)
            
            Text(String(format: "%.2f s", elapsedTime))
                .font(.system(size: 36, weight: .bold, design: .monospaced))
            
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let cellSize = size / CGFloat(gridSize)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: gridSize), spacing: 2) {
                    ForEach(numbers, id: \.self) { number in
                        Button(action: { tapped(number) }) {
                            Text("\(number)")
                                .font(.title2)
                                .fontWeight(.medium)
                                .frame(width: cellSize - 2, height: cellSize - 2)
                                .background(
                                    ZStack {
                                        Color.primary.opacity(0.08)
                                        Color.green.opacity(number < nextTarget && highlightTapped ? 0.5 : 0)
                                        Color.red.opacity(wrongTap == number ? 0.6 : 0)
                                    }
                                        .animation(.linear(duration: 0.15), value: wrongTap)
                                        .cornerRadius(10)
                                )
                                .cornerRadius(10)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(width: size, height: size)
            }
            .aspectRatio(1, contentMode: .fit)
            
            Button("Reset") { resetGame() }
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{ resetGame() }
    }
    
    func tapped(_ number: Int) {
        if number == nextTarget {
            if nextTarget == 1 {
                startTimer()
            }
            nextTarget += 1
            if nextTarget > gridSize * gridSize {
                isFinished = true
                timer?.invalidate()
            }
        } else {
            wrongTap = number
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                wrongTap = nil
            }
        }
    }
    
    func resetGame() {
        numbers = Array(1...gridSize * gridSize).shuffled()
        nextTarget = 1
        isFinished = false
        timer?.invalidate()
        startTime = nil
        elapsedTime = 0
    }
    
    func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let startTime = startTime {
                DispatchQueue.main.async {
                    elapsedTime = Date().timeIntervalSince(startTime)
                }
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
        }
    }
}

//#Preview {
//    ContentView()
//}
