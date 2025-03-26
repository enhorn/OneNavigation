//
//  OneSheetView.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

internal struct OneSheetView<Content: View>: View {

    @State private var height: CGFloat = .zero
    private let content: () -> Content

    init(content: @escaping  () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .overlay { GeometryReader { Color.clear.preference(key: InnerHeightPreferenceKey.self, value: $0.size.height) } }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { new in
                MainActor.assumeIsolated {
                    height = new
                }
            }
            .presentationDetents([.height(height)])
            .background(.backgroundDefaultElevated)
    }

}

fileprivate struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {

    @ViewBuilder func wrappedAsSheet(inSheet: Bool = true) -> some View {
        if inSheet {
            OneSheetView { self }
        } else {
            self
        }
    }

}

#if DEBUG
#Preview("OneSheetView") {
    SheetViewPreview()
}

struct SheetViewPreview: View {

    @State var showSheet: Bool = false

    var body: some View {
        ZStack {
            Button("Show it") {
                showSheet = true
            }
        }.sheet(isPresented: $showSheet) {
            OneSheetView {
                Text(verbatim: "Lorem ipsum dolor sit amet")
                    .multilineTextAlignment(.center)
                    .padding(.small)
            }
        }
    }

}

#endif
