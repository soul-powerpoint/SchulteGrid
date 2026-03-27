//
//  SchulteGrid_iphoneApp.swift
//  SchulteGrid_iphone
//
//  Created by yx h on 27/3/2026.
//

import SwiftUI

@main
struct SchulteGridApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(VisualEffectBlur())
        }
    }
}

#if os(macOS)
struct VisualEffectBlur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .popover
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
#else
struct VisualEffectBlur: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
#endif
