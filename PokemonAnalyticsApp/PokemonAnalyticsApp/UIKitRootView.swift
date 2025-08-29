//
//  UIKitRootView.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 28/08/25.
//

import SwiftUI
import UIKit
import SwiftData

struct UIKitRootView: UIViewControllerRepresentable {

    @Environment(\.modelContext) private var modelContext

    func makeUIViewController(context: Context) -> UINavigationController {
        let nav = UINavigationController()
        let coordinator = AppCoordinator(navigation: nav, modelContainer: modelContext.container)
        context.coordinator.hold = coordinator
        coordinator.start()
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {

    }

    func makeCoordinator() -> Holder {
        Holder()
    }

    final class Holder {
        var hold: AppCoordinator?
    }
}
