//
//  ScratchView.swift
//  ScratchCard
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import SwiftUI

struct ScratchView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var scratchVM: ScratchViewModel

    init(cardVM: ScratchCardViewModel) {
        _scratchVM = State(initialValue: ScratchViewModel(card: cardVM))
    }

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.primary.opacity(0.15))

                VStack(spacing: 12) {
                    if scratchVM.isScratching {
                        Image(systemName: "scribble.variable")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .symbolEffect(.variableColor.iterative.reversing)
                            .transition(.scale.combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: scratchVM.isScratching)

                        Text("Scratching…")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .transition(.opacity)
                    } else if case .scratched(let code) = scratchVM.card.state {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.green)
                            .transition(.scale.combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: scratchVM.card.state)

                        Text("Scratch successful!")
                            .font(.headline)
                            .foregroundStyle(.green)
                            .transition(.opacity)
                        Text("Your code: \(code)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .transition(.opacity)
                    } else {
                        Text("Scratch screen")
                            .font(.title2)
                            .transition(.opacity)
                    }
                }
                .padding()
            }
            .frame(height: 200)
            .animation(.easeInOut, value: scratchVM.isScratching)
            .animation(.easeInOut, value: scratchVM.card.state)

            Button {
                scratchVM.start()
            } label: {
                Text(scratchVM.isScratching ? "Scratching…" : "Scratch")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(scratchVM.isScratching || (scratchVM.card.state == .scratched(code: "")))

            Spacer()
        }
        .padding()
        .navigationTitle("Scratch")
        .onDisappear {
            scratchVM.cancel()
        }
    }
}

#Preview {
    NavigationStack {
        ScratchView(cardVM: ScratchCardViewModel())
    }
}
