//
//  AppCoordinator.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 28/08/25.
//

import UIKit
import SwiftUI
import SwiftData

final class AppCoordinator {
    private let navigation: UINavigationController
    private let modelContainer: ModelContainer
    private let api: PokeAPI

    init(navigation: UINavigationController, modelContainer: ModelContainer) {
        self.navigation = navigation
        self.modelContainer = modelContainer
        
        let httpSession = URLSessionHTTPClient()
        #if DEBUG
        httpSession.simulateError = false
        #endif
        self.api = PokeAPIService(httpClient: httpSession)
    }

    func start() {
        let root = Text("Pokedex") // For testing
        let viewController = UIHostingController(rootView: root)
        viewController.title = "Pokemon"
        navigation.setViewControllers([viewController], animated: false)
    }
}
