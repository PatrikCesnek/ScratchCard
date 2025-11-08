//
//  ScratchCardViewModel.swift
//  ScratchCard
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import SwiftUI

@Observable
final class ScratchCardViewModel {
    enum State: Equatable {
        case unscratched
        case scratching
        case scratched(code: String)
        case activated(code: String)
    }

    var state: State = .unscratched

    func reset() { state = .unscratched }
    func scratching() { state = .scratching }
    func scratched(with code: String) { state = .scratched(code: code) }
    func activated(with code: String) { state = .activated(code: code) }
}

