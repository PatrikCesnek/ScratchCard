//
//  VersionService.swift
//  ScratchCard
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import Foundation

actor VersionService: VersionServiceProtocol {
    enum Error: Swift.Error, LocalizedError {
        case badResponse
        case invalidJSON
        case missingField
        var errorDescription: String? { "Invalid API response." }
    }

    func fetchVersion(for code: String) async throws -> String {
        var components = URLComponents(string: "https://api.o2.sk/version")!
        components.queryItems = [URLQueryItem(name: "code", value: code)]
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw Error.badResponse
        }
        guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let iosValue = dict["ios"] as? String else {
            throw Error.missingField
        }
        return iosValue
    }
}

protocol VersionServiceProtocol: Sendable {
    func fetchVersion(for code: String) async throws -> String
}

