import SwiftUI
import Lumbay2cl

struct ContentView: View {
    @Environment(\.lumbay2Client) var lumbay2Client: Lumbay2Client
    var body: some View {
        VStack {
            Text("Hi")
        }
        .onAppear {
            Task {
                if await lumbay2Client.isPrepared() {
                    print("already prepared")
                    return
                }
                do {
                    try await lumbay2Client.acquirePublicKey(name: "iOS")
                    try await lumbay2Client.acquireClientID()
                    print("preparation OK")
                } catch {
                    print("preparation error:", error.localizedDescription)
                }
            }
        }
    }
}
