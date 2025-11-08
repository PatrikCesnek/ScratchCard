//
//  ScratchCardTests.swift
//  ScratchCardTests
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import Testing
@testable import ScratchCard

// MARK: - Tests
struct ScratchCardDemoTests {

    @Test("ScratchCardViewModel: state transitions")
    func testStateTransitions() async {
        let card = await MainActor.run { ScratchCardViewModel() }

        await MainActor.run {
            #expect(card.state == .unscratched)

            card.scratching()
            #expect(card.state == .scratching)

            card.scratched(with: "CODE123")
            #expect(card.state == .scratched(code: "CODE123"))

            card.activated(with: "CODE123")
            #expect(card.state == .activated(code: "CODE123"))

            card.reset()
            #expect(card.state == .unscratched)
        }
    }

    @Test("Activation succeeds with high enough version")
    func testActivationSucceeds() async throws {
        let card = await MainActor.run { ScratchCardViewModel() }
        await MainActor.run { card.scratched(with: "ABC") }

        let service = VersionServiceMock(result: "18.0")

        let viewModel = await MainActor.run { ActivationViewModel(card: card, service: service) }

        await MainActor.run { viewModel.activate() }

        try await Task.sleep(for: .milliseconds(300))

        await MainActor.run {
            #expect(card.state == .activated(code: "ABC"))
            #expect(viewModel.errorMessage == nil)
        }
    }

    @Test("Activation fails with low version")
    func testActivationFailsLowVersion() async throws {
        let card = await MainActor.run { ScratchCardViewModel() }
        await MainActor.run { card.scratched(with: "XYZ") }

        let service = VersionServiceMock(result: "6.0")
        let viewModel = await MainActor.run { ActivationViewModel(card: card, service: service) }

        await MainActor.run { viewModel.activate() }

        try await Task.sleep(for: .milliseconds(300))

        await MainActor.run {
            #expect(card.state == .scratched(code: "XYZ"))
            #expect(viewModel.errorMessage?.contains("too low") == true)
        }
    }

    @Test("Activation fails with error from service")
    func testActivationFailsWithError() async throws {
        let card = await MainActor.run { ScratchCardViewModel() }
        await MainActor.run { card.scratched(with: "ERR") }

        let service = VersionServiceMock(error: VersionService.Error.badResponse)
        let viewModel = await MainActor.run { ActivationViewModel(card: card, service: service) }

        await MainActor.run { viewModel.activate() }

        try await Task.sleep(for: .milliseconds(300))

        await MainActor.run {
            #expect(card.state == .scratched(code: "ERR"))
            #expect(viewModel.errorMessage?.contains("Invalid API response") == true)
        }
    }
}

// MARK: - Mock for VersionService
actor VersionServiceMock: VersionServiceProtocol {
    private let result: String?
    private let error: Swift.Error?

    init(result: String) {
        self.result = result
        self.error = nil
    }

    init(error: Swift.Error) {
        self.result = nil
        self.error = error
    }

    func fetchVersion(for code: String) async throws -> String {
        if let error { throw error }
        guard let result else { throw VersionService.Error.missingField }
        return result
    }
}
