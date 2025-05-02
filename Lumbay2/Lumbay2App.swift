import SwiftUI
import Lumbay2cl
import UIKit

@main
struct Lumbay2App: App {
    
    let client: Lumbay2Client
    
    @State var clientOkay: Bool = false
    @State var subscribeTask: Task<Void, Error>? = nil
    @State var gameStatus: Lumbay2sv_GameStatus = .none
    @State var gameCode: String = ""
    @State var world: Lumbay2sv_World = Lumbay2sv_World()
    
    init() {
#if targetEnvironment(simulator)
        client = Lumbay2Client(host: "192.168.1.2", port: 50052, useTLS: false)
#else
        client = Lumbay2Client(host: "outgoing-tuna-polite.ngrok-free.app", port: nil, useTLS: true)
#endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.client, client)
                .environment(\.clientOkay, $clientOkay)
                .environment(\.subscribeTask, $subscribeTask)
                .environment(\.gameStatus, $gameStatus)
                .environment(\.gameCode, $gameCode)
                .environment(\.world, $world)
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
