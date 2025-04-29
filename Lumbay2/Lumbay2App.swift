import SwiftUI
import Lumbay2cl

@main
struct Lumbay2App: App {
    
#if targetEnvironment(simulator)
    let client: Lumbay2Client = Lumbay2Client(host: "192.168.1.2", port: 50052, useTLS: false)
#else
    let client: Lumbay2Client = Lumbay2Client(host: "outgoing-tuna-polite.ngrok-free.app", port: nil, useTLS: true)
#endif
    
    @State var clientOkay = false
    @State var subscribeTask: Task<Void, Error>? = nil
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.client, client)
                .environment(\.clientOkay, $clientOkay)
                .environment(\.subscribeTask, $subscribeTask)
                .task {
                    await client
                        .loadPublicKey(loadPublicKey)
                        .savePublicKey(savePublicKey)
                        .loadClientID(loadClientID)
                        .saveClientID(saveClientID)
                        .handleUpdate(processUpdate)
                        .prepareAndSubscribe($clientOkay, $subscribeTask)
                }
        }
    }
}
