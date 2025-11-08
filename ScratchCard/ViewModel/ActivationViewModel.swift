//
//  ActivationViewModel.swift
//  ScratchCard
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import Foundation

@Observable
final class ActivationViewModel {
    var isActivating = false
    var errorMessage: String?
    let card: ScratchCardViewModel
    private let service: VersionServiceProtocol

    init(card: ScratchCardViewModel, service: VersionServiceProtocol? = nil) {
        self.card = card
        self.service = service ?? VersionService()
    }

    func activate() {
        guard case let .scratched(code) = card.state else {
            errorMessage = "No code to activate."
            return
        }

        isActivating = true
        errorMessage = nil

        Task.detached {
            do {
                let ios = try await self.service.fetchVersion(for: code)
                if Double(ios) ?? 0 > 6.1 {
                    await MainActor.run {
                        self.card.activated(with: code)
                        self.isActivating = false
                    }
                } else {
                    await MainActor.run {
                        self.errorMessage = "Version \(ios) too low."
                        self.isActivating = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isActivating = false
                }
            }
        }
    }
}
