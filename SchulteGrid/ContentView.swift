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
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: gridSize)
    }
    
    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, id: \.self, selection: $selectedTab) { item in
                Label(item.rawValue, systemImage: item == .game ? "gamecontroller" : "gearshape")
            }
            .navigationSplitViewColumnWidth(min: 150, ideal: 180, max: 220)
        } detail: {
            switch selectedTab {
            case .game:
                gameView
            case .settings:
                SettingView(gridSize: $gridSize)
            }
        }
        .onChange(of: gridSize) {
            resetGame()
        }
    }
    
    var gameView: some View {
        VStack(spacing: 20) {
            Text("Tap \(nextTarget)")
                .font(.title2)
            
            Text(String(format: "%.1f s", elapsedTime))
                .font(.system(size: 36, weight: .bold, design: .monospaced))
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(numbers, id: \.self) { number in
                    Button(action: { tapped(number) }) {
                        Text("\(number)")
                            .font(.title2)
                            .fontWeight(.medium)
                            .frame(width: 60, height: 60)
                            .backgroundStyle(number < nextTarget ? Color.green.opacity(0.3) : Color.blue.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .cornerRadius(8)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            
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
