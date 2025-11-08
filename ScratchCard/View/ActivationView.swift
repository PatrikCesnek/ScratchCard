//
//  ActivationView.swift
//  ScratchCard
//
//  Created by Patrik Cesnek on 08/11/2025.
//

import SwiftUI

struct ActivationView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var vm: ActivationViewModel

    init(cardVM: ScratchCardViewModel) {
        _vm = State(initialValue: ActivationViewModel(card: cardVM))
    }

    var body: some View {
        VStack(spacing: 20) {
            if !isCardActivated {
                Text("Activation")
                    .font(.title2)

                Button("Activate") {
                    vm.activate()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .disabled(vm.isActivating || isCardActivated)
            }

            if vm.isActivating {
                ProgressView("Activating…")
            }

            if let error = vm.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            if isCardActivated {
                VStack(spacing: 10) {
                    Text("Your card has been activated, return to previous screen")

                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.green)
                        .transition(.scale.combined(with: .opacity))

                    Text("Activated successfully!")
                        .font(.headline)
                        .foregroundStyle(.green)
                }
                .animation(.spring, value: vm.card.state)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Activation")
    }

    private var isCardActivated: Bool {
        if case .activated = vm.card.state {
            true
        } else {
            false
        }
    }
}

#Preview {
    let card = ScratchCardViewModel()
    card.scratched(with: "PREVIEW-CODE")
    return NavigationStack {
        ActivationView(cardVM: card)
    }
}
