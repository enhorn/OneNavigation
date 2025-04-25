//
//  OneNavigationStack.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

/// Implementation of the navigation stack. It's easier to use the ``OneNavStack`` version.
public struct OneNavigationStack<Path: OneNavigationPath, Root: View>: View {

    @State var pathManager = OnePathManager<Path>()

    @State private var errorManager = OneErrorManager<Path>()

    @State private var bannerError: OneDisplayableError?
    @State private var sheetError: OneDisplayableError?

    @ViewBuilder var root: (OneErrorManager<Path>, OnePathManager<Path>) -> Root

    private var path: Binding<[Path]> {
        if OneDevice.isMacos {
            $pathManager.path.animation(.easeOut(duration: .long))
        } else {
            $pathManager.path
        }
    }
    
    /// Designated initializer.
    /// - Parameter root: View builder block with error manager & path manager.
    public init(@ViewBuilder root: @escaping (OneErrorManager<Path>, OnePathManager<Path>) -> Root) {
        self.root = root
    }

    /// Designated initializer.
    /// - Parameter root: View builder block without parameters.
    public init(@ViewBuilder root: @escaping () -> Root) {
        self.root = { _, _ in root() }
    }

    public var body: some View {
        VStack(spacing: .zero) {

            if !OneDevice.isMacos, let bannerError {
                OneErrorBanner(error: bannerError) {
                    errorManager.remove(error: bannerError)
                }.transition(.move(edge: .top).combined(with: .opacity))
            }

            navStack()
                .environment(errorManager)
                .environment(pathManager)
        }
        .animation(.bouncy, value: bannerError)
        .onChange(of: errorManager.pathErrors) { updateErrors() }
        .onChange(of: errorManager.rootErrors) { updateErrors() }
        .onChange(of: pathManager.path) { old, new in
            if old.count > new.count, let bannerError {
                errorManager.remove(error: bannerError)
            }
            updateErrors()
        }
    }

}

private extension OneNavigationStack {

    func navStack() -> some View {
        NavigationStack(path: path) {
            root(errorManager, pathManager)
                .navigationDestination(for: Path.self) { path in
                    VStack(spacing: .zero) {
                        if OneDevice.isMacos, let bannerError {
                            OneErrorBanner(error: bannerError) {
                                errorManager.remove(error: bannerError)
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        path.destination(using: pathManager)
                            .environment(errorManager)
                            .environment(pathManager)
                    }.animation(.easeInOut, value: bannerError)
                }
                .sheet(item: $sheetError) { sheet in
                    errorSheet(for: sheet)
                }
        }
        .sheet(item: $pathManager.modal, content: { [weak pathManager] presentable in
            if pathManager != nil {
                modal(for: presentable)
            }
        })
    }

    func updateErrors() {
        DispatchQueue.main.async {
            updateErrorBanner()
            updateErrorSheets()
        }
    }

    func updateErrorSheets() {
        if let lastPath = pathManager.path.last {
            sheetError = errorManager.pathErrors[lastPath]?.filter(\.isSheet).last
        } else {
            sheetError = errorManager.rootErrors.filter(\.isSheet).last
        }
    }

    func updateErrorBanner() {
        if let lastPath = pathManager.path.last {
            bannerError = errorManager.pathErrors[lastPath]?.filter(\.isBanner).last
        } else {
            bannerError = errorManager.rootErrors.filter(\.isBanner).last
        }
    }

    @ViewBuilder func modal(for modal: OnePathManager<Path>.Modal) -> some View {
        if modal.inNavigationStack {
            OneNavStack { _, pathManager in
                (pathManager as? OnePathManager<Path>)?.parent = self.pathManager
                return modal.path.destination(using: pathManager)
            }
        } else {
            modal.path.destination(using: pathManager)
        }
    }

    @ViewBuilder func errorSheet(for error: OneDisplayableError) -> some View {
        switch error {
            case .banner: EmptyView()
            case .confirmation(let message, let confirmTitle, let cancel, let confirm, let always):
                OneConfirmationSheet(
                    message: message,
                    cancel: .cancel(action: { DispatchQueue.main.async(execute: cancel) }),
                    action: .primary(confirmTitle, action: { DispatchQueue.main.async(execute: confirm) }),
                    always: {
                        errorManager.remove(error: error)
                        DispatchQueue.main.async(execute: always)
                    }
                )
            case .alert(message: let message, icon: let icon):
                OneSheetView {
                    VStack(spacing: .small) {
                        Image(systemSymbol: icon).font(.largeTitle).padding(.top, .small)
                        Text(message).padding(.vertical, .small)
                        OneRoundedButton(title: "OK", style: .primary) {
                            errorManager.remove(error: error)
                        }
                    }
                    .padding(.small)
                }
        }
    }

}

#if DEBUG

#Preview("Nav Stack") {
    OneNavigationStack<OneExamplePath, Button> { errorManager, pathManager in
        Button("Hello") {
            errorManager.showRoot(error: .alert(message: "Hello"))
        }
    }
}

@MainActor fileprivate struct OneExamplePath: OneNavigationPath {

    nonisolated var id: String { title }

    let title: String

    @MainActor @ViewBuilder func destination<Path: OneNavigationPath>(using pathManager: OnePathManager<Path>) -> AnyView {
        AnyView(body)
    }

    private var body: some View {
        VStack(spacing: .small) {
            Text(title).font(.title)
            Text(title)
        }
    }
}

#endif
