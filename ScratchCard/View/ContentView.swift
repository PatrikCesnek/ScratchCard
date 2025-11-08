//
//  ContentView.swift
//  ScratchCard
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var cardVM = ScratchCardViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ScratchCardStateView(state: cardVM.state)
                    .padding()

                NavigationLink("Go to Scratch Screen") {
                    ScratchView(cardVM: cardVM)
                }

                NavigationLink("Go to Activation Screen") {
                    ActivationView(cardVM: cardVM)
                }

                Spacer()
            }
            .navigationTitle("Scratch Card")
            .padding()
        }
    }
}

struct ScratchCardStateView: View {
    let state: ScratchCardViewModel.State

    var body: some View {
        VStack(spacing: 8) {
            Text("Card state:")
                .font(.headline)
            switch state {
            case .unscratched:
                Text("Unscratched")
                    .foregroundStyle(.secondary)
            case .scratching:
                Text("Scratching…")
                    .foregroundStyle(.orange)
            case .scratched(let code):
                Text("Scratched — code: \(code)")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            case .activated(let code):
                Text("Activated — code: \(code)")
                    .font(.caption)
                    .foregroundStyle(.green)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
