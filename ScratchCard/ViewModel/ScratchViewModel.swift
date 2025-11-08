//
//  ScratchViewModel.swift
//  ScratchCard
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import Foundation

@Observable
final class ScratchViewModel {
    var isScratching = false
    var card: ScratchCardViewModel
    var code: String?

    init(card: ScratchCardViewModel) {
        self.card = card
    }

    private var task: Task<Void, Never>?

    func start() {
        guard !isScratching else { return }
        isScratching = true
        card.scratching()

        task = Task {
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled else {
                await MainActor.run { self.card.reset() }
                return
            }
            code = UUID().uuidString
            guard let code = code else { return }
            await MainActor.run {
                self.card.scratched(with: code)
                self.isScratching = false
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
        isScratching = false
    }
}

