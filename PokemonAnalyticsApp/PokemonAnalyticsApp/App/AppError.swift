//
//  AppError.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import Foundation

/// Type error container. HTTP, decoding and persistence failures
enum AppError: Error, LocalizedError, Equatable {
    // MARK: Network
    case network(URLError)
    case timeout
    case http(Int)
    case unauthorized
    case forbidden

    // MARK: Parsing
    case decoding(DecodingError)
    case invalidResponse(String)

    // MARK: App
    case offline
    case persistence(String)
    case other(String)

    var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .timeout:
            return "Request timed out."
        case .http(let code):
            return "HTTP \(code)"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .decoding:
            return "Failed to decode response"
        case .invalidResponse(let error):
            return error
        case .offline:
            return "No internet"
        case .persistence(let error):
            return error
        case .other(let error):
            return error
        }
    }

    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.timeout, .timeout), (.unauthorized, .unauthorized),
            (.forbidden, .forbidden), (.offline, .offline),
            (.decoding, .decoding):
            return true
        case (.http(let codeA), .http(let codeB)):
            return codeA == codeB
        case (.invalidResponse(let errorA), .invalidResponse(let errorB)):
            return errorA == errorB
        case (.persistence(let errorA), .persistence(let errorB)):
            return errorA == errorB
        case (.other(let errorA), .other(let errorB)):
            return errorA == errorB
        case (.network(let errorA), .network(let errorB)):
            return errorA.code == errorB.code
        default:
            return false
        }
    }
}
