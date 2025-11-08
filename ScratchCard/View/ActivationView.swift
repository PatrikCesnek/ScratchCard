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
    @Binding var path: NavigationPath

    init(cardVM: ScratchCardViewModel, path: Binding<NavigationPath>) {
        _vm = State(initialValue: ActivationViewModel(card: cardVM))
        _path = path
    }

    var body: some View {
        VStack(spacing: 20) {
            if !isCardActivated {
                Text("Tap the button to Activate your code!")
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

            if isCardActivated {
                VStack(spacing: 10) {
                    Text("Your card has been activated, return to previous screen")

                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.green)

                    Text("Activated successfully!")
                        .font(.headline)
                        .foregroundStyle(.green)
                }
                .animation(.spring, value: vm.card.state)

                Button("Return Home") {
                    // Clear navigation path to go back to root
                    path.removeLast(path.count)
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Activation")
        .sheet(isPresented: errorSheetBinding) {
            VStack(spacing: 24) {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(.red)
                Text(vm.errorMessage ?? "Something went wrong, your version is probably too low")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                Button("Dismiss") {
                    vm.errorMessage = nil
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            .padding()
            .presentationDetents([.medium])
        }
    }

    private var isCardActivated: Bool {
        if case .activated = vm.card.state { true } else { false }
    }

    private var errorSheetBinding: Binding<Bool> {
        Binding(
            get: { vm.errorMessage != nil },
            set: { newValue in
                if !newValue {
                    vm.errorMessage = nil
                }
            }
        )
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let card = ScratchCardViewModel()
    card.scratched(with: "PREVIEW-CODE")

    return NavigationStack(path: $path) {
        ActivationView(cardVM: card, path: $path)
    }
}
