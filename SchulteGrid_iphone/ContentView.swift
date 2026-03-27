//
//  ContentView.swift
//  SchulteGrid_iphone
//
//  Created by yx h on 27/3/2026.
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
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: gridSize)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            gameView
                .tabItem { Label("Game", systemImage: "gamecontroller") }
                .tag(SidebarItem.game)
            
            SettingView(gridSize: $gridSize, highlightTapped: $highlightTapped)
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(SidebarItem.settings)
        }
    }
    
    var gameView: some View {
        VStack(spacing: 20) {
            Text("Tap \(nextTarget)")
                .font(.title2)
            
            Text(String(format: "%.1f s", elapsedTime))
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
                                        VisualEffectBlur()
                                        Color.white.opacity(number < nextTarget && highlightTapped ? 0.4 : 0.15)
                                    }
                                    .cornerRadius(6)
                                )
                                .cornerRadius(6)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(width: size, height: size)
            }
            .aspectRatio(1, contentMode: .fit)
            
            if isFinished {
                Text("Done!").font(.title)
            }
            
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
                elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
