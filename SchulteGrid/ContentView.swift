//
//  ContentView.swift
//  SchulteGrid
//
//  Created by yx h on 26/3/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var gridSize = 5
    @State private var numbers: [Int] = []
    @State private var nextTarget = 1
    @State private var isFinished = false
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: gridSize)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tap \(nextTarget)").font(.title2)
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(numbers, id: \.self) { number in
                    Button(action: { tapped(number) }) {
                        Text("\(number)")
                            .frame(width: 50, height: 50)
                            .backgroundStyle(number < nextTarget ? Color.green.opacity(0.3) : Color.blue.opacity(0.2))
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
        .onAppear{ resetGame() }
    }
    
    func tapped(_ number: Int) {
        if number == nextTarget {
            nextTarget += 1
            if nextTarget > gridSize * gridSize {
                isFinished = true
            }
        }
    }
    
    func resetGame() {
        numbers = Array(1...gridSize * gridSize).shuffled()
        nextTarget = 1
        isFinished = false
    }
}

//#Preview {
//    ContentView()
//}
