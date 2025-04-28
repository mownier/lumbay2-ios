import SwiftUI
import Lumbay2cl


@main
struct Lumbay2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
#if targetEnvironment(simulator)
                .environment(\.lumbay2Client, Lumbay2Client(host: "192.168.1.2", port: 50052, useTLS: false))
#else
                .environment(\.lumbay2Client, Lumbay2Client(host: "outgoing-tuna-polite.ngrok-free.app", port: nil, useTLS: true))
#endif
        }
    }
}


