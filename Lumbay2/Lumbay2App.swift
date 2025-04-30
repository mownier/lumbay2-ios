import SwiftUI
import Lumbay2cl
import UIKit

@main
struct Lumbay2App: App {
    
    let userDefaultsPrefixKey: String
    let client: Lumbay2Client
    
    @State var clientOkay = false
    @State var subscribeTask: Task<Void, Error>? = nil
    @State var gameStatus: Lumbay2sv_GameStatus = .none
    @State var gameCode: String = ""
    
    init() {
#if targetEnvironment(simulator)
        client = Lumbay2Client(host: "192.168.1.2", port: 50052, useTLS: false)
        if let configIndex = ProcessInfo.processInfo.arguments.firstIndex(of: "-UserDefaultsPrefixKey"),
           configIndex + 1 < ProcessInfo.processInfo.arguments.count {
            userDefaultsPrefixKey = ProcessInfo.processInfo.arguments[configIndex + 1]
        } else {
            userDefaultsPrefixKey = ""
        }
#else
        client = Lumbay2Client(host: "outgoing-tuna-polite.ngrok-free.app", port: nil, useTLS: true)
        userDefaultsPrefixKey = ""
#endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.client, client)
                .environment(\.userDefaultsPrefixKey, userDefaultsPrefixKey)
                .environment(\.clientOkay, $clientOkay)
                .environment(\.subscribeTask, $subscribeTask)
                .environment(\.gameStatus, $gameStatus)
                .environment(\.gameCode, $gameCode)
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
