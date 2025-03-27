# OneNavigation
Imperative navigation for SwiftUI

This is a simple package for being able to do some imperative navigation and error presentations in SwiftUI without the use of navigation links and storing properties.

This is done by wrapping and and managing a SwiftUI navigation stack.

Runnable example is available in the example Xcode project.

Code example:

```swift
import OneNavigation

struct ContentView: View {

    var body: some View {
        OneNavStack { errorManager, pathManager in // Optional parameters, can be empty.
            VStack {

                Button("Error") {
                    errorManager.showRoot(error: .alert(message: "Hello"))
                }

                Button("Present modal") {
                    // Modally presenting `some View`.
                    // Will be wrapped in a `OneNavStack` by default.
                    pathManager.present(id: "Presented view") {
                        VStack { // The view that will be presented modally.

                            PushPreview() // See below. Button that will push views in the påresented navigation stack.

                            Button("Dismiss") {
                                pathManager.dismiss() // Path manager from the presenter
                            }

                        }
                    }
                }

            }
        }
    }
    
}

struct PushPreview: View {

    // Path manager & error manager from the automatically wrapping `OneNavStack`.
    // These are available as environment variables to anything inside a `OneNavStack` or `OneNavigationStack`.
    @Environment(OnePathManager<OneNavPath>.self) var pathManager
    @Environment(OneErrorManager<OneNavPath>.self) var errorManager

    var body: some View {
        Button("Push") {
            pathManager.push(id: "Pushed view") {
                VStack { // View that will be pushed in the navigation stack.

                    Button("Pop") {
                        pathManager.pop()
                    }

                    Button("Show error banner") {
                        // Errors are presented for specified navigation paths.
                        errorManager.show(
                            error: .banner(message: "Error banner", dismissType: .automatic),
                            forPath: .identifierOnly("Pushed view")
                        )
                    }

                    Button("Dismiss modal from inside pushed view") {
                        pathManager.dismiss()
                    }

                }
            }
        }
    }

}

```
