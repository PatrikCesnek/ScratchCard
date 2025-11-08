//
//  ScratchCardState.swift
//  ScratchCard
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import Foundation

enum ScratchCardState: Equatable {
    case unscratched
    case scratching
    case scratched(code: String)
    case activated(code: String)
}

extension ScratchCardState {
    var code: String? {
        switch self {
        case .scratched(let code): return code
        case .activated(let code): return code
        default: return nil
        }
    }
}
