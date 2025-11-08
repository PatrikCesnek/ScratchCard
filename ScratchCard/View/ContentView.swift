//
//  ContentView.swift
//  ScratchCard
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var cardVM = ScratchCardViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                ScratchCardStateView(state: cardVM.state)
                    .padding()

                NavigationLink(value: "scratch") {
                    Text("Go to Scratch Screen")
                }

                NavigationLink(value: "activate") {
                    Text("Go to Activation Screen")
                }

                Spacer()
            }
            .navigationTitle("Scratch Card")
            .navigationDestination(for: String.self) { route in
                switch route {
                case "scratch":
                    ScratchView(cardVM: cardVM, path: $path)
                case "activate":
                    ActivationView(cardVM: cardVM, path: $path)
                default:
                    EmptyView()
                }
            }
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
