//
//  HTTPClientTests.swift
//  PokemonAnalyticsAppTests
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import XCTest
@testable import PokemonAnalyticsApp

private final class MockHTTPClient: HTTPClient {
    var simulateError: Bool = false
    var response: (Data, HTTPURLResponse)?

    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if simulateError { throw AppError.network(URLError(.notConnectedToInternet)) }
        if let response { return response }
        throw AppError.other("No stub")
    }
}

final class HTTPClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testDecodingOK() async throws {
        let mock = MockHTTPClient()
        let json = """
        {
            "count":2,
            "next":null,
            "previous":null,
            "results":[
                {"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon/1/"},
                {"name":"ivysaur","url":"https://pokeapi.co/api/v2/pokemon/2/"}
            ]
        }
        """.data(using: .utf8)!
        let ok = HTTPURLResponse(url: NetworkConfig.baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mock.response = (json, ok)

        let apiService = PokeAPIService(httpClient: mock)
        do {
            let data = try await apiService.list(offset: 0, limit: 2)
            XCTAssertEqual(data.results.count, 2)
        } catch {
            XCTFail()
        }
       
    }

    func testSimulatedOffline() async throws {
        let mock = MockHTTPClient()
        mock.simulateError = true
        let api = PokeAPIService(httpClient: mock)
        do {
            _ = try await api.pokemon(id: 1); XCTFail("should fail")
        } catch let error as AppError {
            if case .network = error {
                print("ok")
            } else {
                XCTFail()
            }
        }
    }

}
