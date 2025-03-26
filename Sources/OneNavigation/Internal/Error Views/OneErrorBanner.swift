//
//  OneErrorBanner.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI
import SFSafeSymbols

internal struct OneErrorBanner: View {

    let error: OneDisplayableError
    let dismiss: () -> Void

    init?(error: OneDisplayableError, dismiss: @escaping () -> Void) {
        guard error.isBanner else { return nil }
        self.error = error
        self.dismiss = dismiss
    }

    var body: some View {
        HStack(alignment: .bottom) {
            HStack(alignment: .center) {

                Image(systemSymbol: error.icon).foregroundStyle(.foregroundDefaultInverted)
                Text(error.message).font(.body).foregroundStyle(.foregroundDefaultInverted)
                Spacer(minLength: .small)

                if case .banner(_, _, let dismissType) = error, dismissType == .dismiss {
                    Button(action: dismiss) {
                        Image(systemSymbol: .xmark)
                    }.foregroundStyle(.foregroundDefaultInverted)
                }

            }
        }
        .padding(.small)
        .edgesIgnoringSafeArea(.horizontal)
        .background(.backgroundError)
        .onAppear {
            if case .banner(_, _, let dismissType) = error, case .automatic(let time) = dismissType {
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    dismiss()
                }
            }
        }
    }

}

#if DEBUG
#Preview("OneErrorBanner") {
    VStack {
        OneErrorBanner(error: .banner(message: "Error message", icon: .heart, dismissType: .none), dismiss: { })
        OneErrorBanner(error: .banner(message: "Error message", icon: .heart, dismissType: .automatic(3)), dismiss: { print("Automatic dismiss callback called") })
        OneErrorBanner(error: .banner(message: "Error message", icon: .heart, dismissType: .dismiss), dismiss: { print("Dismiss callback called") })
    }
}
#endif
