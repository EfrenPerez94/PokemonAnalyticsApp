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
    private let tabBar = UITabBarController()
    private let modelContainer: ModelContainer
    private let api: PokeAPI

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer

        let http = URLSessionHTTPClient()
        #if DEBUG
        http.simulateError = false
        #endif
        self.api = PokeAPIService(httpClient: http)
    }

    @MainActor
    func start(in navController: UINavigationController) {
        let tabBarCoordinator = TabBarCoordinator(api: api, modelContainer: modelContainer)
        tabBarCoordinator.start(on: tabBar)
        navController.setViewControllers([tabBar], animated: false)
        navController.isNavigationBarHidden = true
    }
}
