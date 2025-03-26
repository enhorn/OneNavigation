//
//  ContentView.swift
//  OneNavExample
//
//  Created by Robin Enhorn on 2025-03-26.
//

import SwiftUI
import OneNavigation

struct ContentView: View {

    var body: some View {
        OneNavStack { errorManager, pathManager in
            VStack(spacing: 24) {

                Button("Error") {
                    errorManager.showRoot(error: .alert(message: "Hello"))
                }

                Button("Present modal") {
                    // Modally presenting `some View`.
                    // Will be wrapped in a `OneNavStack`.
                    pathManager.present(id: "Presented view", inNavigationStack: true) {
                        VStack(spacing: 24) {

                            PushPreview() // See below

                            Button("Dismiss") {
                                pathManager.dismiss() // Path manager from the presenter
                            }

                        }.navigationTitle("Presented")
                    }
                }

            }
        }
    }
    
}

struct PushPreview: View {

    // Path manager & error manager from the automatically wrapping `OneNavStack`.
    // These are available as environment variables to anything inside a `OneNavStack` or `OneNavigationStack`.
    @Environment(OnePathManager<OneGenericNavPath>.self) var pathManager
    @Environment(OneErrorManager<OneGenericNavPath>.self) var errorManager

    var body: some View {
        Button("Push") {
            pathManager.push(id: "Pushed view") {
                VStack(spacing: 24) {

                    Button("Pop") {
                        pathManager.pop()
                    }

                    Button("Show error banner") {
                        errorManager.show(
                            error: .banner(message: "Error banner", dismissType: .automatic),
                            forPath: .identifierOnly("Pushed view")
                        )
                    }

                    Button("Dismiss from pushed") {
                        pathManager.dismiss()
                    }

                }.navigationTitle("Pushed")
            }
        }
    }

}

#Preview {
    ContentView()
}
