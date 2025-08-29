//
//  HTTPClient.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import Foundation

/// HTTP client abstraction for async/await requests.
protocol HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
    var simulateError: Bool { get set }
}

/// URLSession connection
final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    var simulateError: Bool = false

    init(session: URLSession = NetworkConfig.session) {
        self.session = session
    }

    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        #if DEBUG
        if simulateError {
            throw AppError.network(URLError(.notConnectedToInternet))
        }
        #endif

        do {
            let (data, httpResponse) = try await session.data(for: request)
            guard let httpResponse = httpResponse as? HTTPURLResponse else {
                throw AppError.invalidResponse("No HTTP response")
            }
            switch httpResponse.statusCode {
            case 200...299:
                return (data, httpResponse)
            case 401:
                throw AppError.unauthorized
            case 403:
                throw AppError.forbidden
            default:
                throw AppError.http(httpResponse.statusCode)
            }

        } catch let error as URLError {
            if error.code == .timedOut { throw AppError.timeout }
            throw AppError.network(error)
        } catch let error as DecodingError {
            throw AppError.decoding(error)
        } catch {
            throw AppError.other(error.localizedDescription)
        }

    }
}
