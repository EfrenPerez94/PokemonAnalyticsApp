//
//  AppCoordinator.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 28/08/25.
//

import UIKit
import SwiftUI

final class AppCoordinator {
    private let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    func start() {
        let root = Text("Pokedex") // For testing
        let vc = UIHostingController(rootView: root)
        vc.title = "Pokemon"
        navigation.setViewControllers([vc], animated: false)
    }
}
