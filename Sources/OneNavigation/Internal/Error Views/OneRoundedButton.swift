//
//  OneRoundedButton.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

internal struct OneRoundedButton: View {

    enum Style: Equatable {
        case primary, secondary, destructive
    }

    @Environment(\.isEnabled) private var isEnabled: Bool

    let title: String
    let style: Style
    let action: () -> Void

    init(title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(title, action: action)
            .buttonStyle(Styling(style: style, isEnabled: isEnabled))
            .accessibilityIdentifier(title)
    }

    private struct Styling: ButtonStyle {

        let style: OneRoundedButton.Style
        let isEnabled: Bool

        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.small)
                .background(style.backgroundColor(isEnabled: isEnabled))
                .foregroundStyle(style.foregroundColor(isEnabled: isEnabled))
                .cornerRadius(.xSmall)
                .overlay { style.border(isEnabled: isEnabled) }
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                .brightness(configuration.isPressed ? -0.1 : 0)
                .scaleEffect(configuration.isPressed ? 0.98 : 1)
                .animation(.easeInOut(duration: .short), value: configuration.isPressed)
        }

    }

}

extension OneRoundedButton {

    static func primary(_ title: String, action: @escaping () -> Void) -> OneRoundedButton {
        OneRoundedButton(title: title, style: .primary, action: action)
    }

    static func secondary(_ title: String, action: @escaping () -> Void) -> OneRoundedButton {
        OneRoundedButton(title: title, style: .secondary, action: action)
    }

    static func destructive(_ title: String, action: @escaping () -> Void) -> OneRoundedButton {
        OneRoundedButton(title: title, style: .destructive, action: action)
    }

}

private extension OneRoundedButton.Style {

    func foregroundColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return .white.opacity(0.7) }
        return switch self {
            case .primary, .destructive: .foregroundDefaultInverted
            case .secondary: .foregroundDefault
        }
    }

    func backgroundColor(isEnabled: Bool) ->  Color? {
        guard isEnabled else { return .gray }
        return switch self {
            case .primary: .accentColor
            case .secondary: .backgroundDefault
            case .destructive: .red
        }
    }

    @ViewBuilder func border(isEnabled: Bool) -> some View {
        if !isEnabled {
            RoundedRectangle(cornerRadius: .xSmall)
                .stroke(.borderDefault, lineWidth: 1)
                .contentShape(Rectangle())
        }
    }

}

#if DEBUG
#Preview("OneRoundedButton") {
    RoundedButtonPreview()
}

struct RoundedButtonPreview: View {

    var body: some View {
        ScrollView {
            VStack(spacing: .small) {
                OneRoundedButton(title: "Primary", style: .primary) { }
                OneRoundedButton(title: "Secondary", style: .secondary) { }
                OneRoundedButton(title: "Destructive", style: .destructive) { }
            }.padding(16)
        }
    }

}

#endif

