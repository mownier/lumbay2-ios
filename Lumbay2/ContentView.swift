import SwiftUI
import Lumbay2cl

struct ContentView: View {
    @Environment(\.client) var client: Lumbay2Client
    @Environment(\.clientOkay) var clientOkay: Binding<Bool>
    @Environment(\.subscribeTask) var subscribeTask: Binding<Task<Void, Error>?>
    
    var body: some View {
        VStack {
            Text("Hi")
            Button(
                action: {
                    if clientOkay.wrappedValue {
                        subscribeTask.wrappedValue?.cancel()
                        subscribeTask.wrappedValue = nil
                        return
                    }
                    Task {
                        await client.prepareAndSubscribe(clientOkay, subscribeTask)
                    }
                },
                label: {
                    Text(clientOkay.wrappedValue ? "Disconnect" : "Connect")
                }
            )
        }
    }
}
