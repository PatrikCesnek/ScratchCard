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
    @Binding var path: NavigationPath

    init(cardVM: ScratchCardViewModel, path: Binding<NavigationPath>) {
        _scratchVM = State(initialValue: ScratchViewModel(card: cardVM))
        _path = path
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

                        Text("Scratching…")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    } else if case .scratched(let code) = scratchVM.card.state {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.green)
                        Text("Scratch successful!")
                            .font(.headline)
                            .foregroundStyle(.green)
                        Text("Your code: \(code)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Scratch screen")
                            .font(.title2)
                    }
                }
                .padding()
            }
            .frame(height: 200)

            if scratchVM.code != nil {
                Button("Activate") {
                    path.append("activate")
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
            } else {
                Button {
                    scratchVM.start()
                } label: {
                    Text(scratchVM.isScratching ? "Scratching…" : "Scratch")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(scratchVM.isScratching)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Scratch")
        .onDisappear { scratchVM.cancel() }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack(path: $path) {
        ScratchView(
            cardVM: ScratchCardViewModel(),
            path: $path
        )
    }
}
