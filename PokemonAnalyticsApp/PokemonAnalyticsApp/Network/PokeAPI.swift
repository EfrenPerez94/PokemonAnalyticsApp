//
//  PokeAPI.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import Foundation

/// Interface for PokeAPI client
protocol PokeAPI {
    func list(offset: Int, limit: Int) async throws -> PokemonsListModel
    func pokemon(id: Int) async throws -> PokemonDetailModel
}

/// Poke API service connection
final class PokeAPIService: PokeAPI {
    private let httpClient: HTTPClient
    private let baseURL: URL
    private let decoder: JSONDecoder

    init(httpClient: HTTPClient, baseURL: URL = NetworkConfig.baseURL, decoder: JSONDecoder = NetworkConfig.decoder) {
        self.httpClient = httpClient
        self.baseURL = baseURL
        self.decoder = decoder
    }

    func list(offset: Int, limit: Int) async throws -> PokemonsListModel {
        var components = URLComponents(url: baseURL.appendingPathComponent("pokemon"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "offset", value: String(offset)),
                                 URLQueryItem(name: "limit", value: String(limit)) ]

        let request = URLRequest(url: components.url!)

        let (data, _) = try await httpClient.data(for: request)

        return try decoder.decode(PokemonsListModel.self, from: data)
    }

    func pokemon(id: Int) async throws -> PokemonDetailModel {
        let url = baseURL.appendingPathComponent("pokemon/\(id)")
        let request = URLRequest(url: url)
        let (data, _) = try await httpClient.data(for: request)

        return try decoder.decode(PokemonDetailModel.self, from: data)
    }
}
