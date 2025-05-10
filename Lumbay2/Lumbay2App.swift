import SwiftUI
import Lumbay2cl
import UIKit

@main
struct Lumbay2App: App {
    
    let client: Lumbay2Client = Lumbay2Client()
    let audioManager: AudioManager = AudioManager()
    
    @State var clientOkay: Bool = false
    @State var subscribeTask: Task<Void, Error>? = nil
    @State var gameStatus: Lumbay2sv_GameStatus = .none
    @State var gameCode: String = ""
    @State var worldID: Lumbay2sv_WorldId = .none
    @State var worldOneStatus: Lumbay2sv_WorldOneStatus = .none
    @State var worldOneRegionID: Lumbay2sv_WorldOneRegionId = .none
    @State var worldOneObject: Lumbay2sv_WorldOneObject?
    @State var worldOneAssignedStone: WorldOneAssignedStone = .none
    @State var worldOneScore: Lumbay2sv_WorldOneScore = Lumbay2sv_WorldOneScore()
    @State var initialDataStatus: Lumbay2sv_InitialDataStatus = .none
    @State var initialUpdates: [Lumbay2sv_Update] = []
    @State var initialDataProcess: InitialDataProcess = .none
    @State var initialDataWorldOneObjects: [Lumbay2sv_WorldOneObject] = []
    @State var clientSettings: ClientSettings = ClientSettings()
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.client, client)
                .environment(\.audioManager, audioManager)
                .environment(\.clientOkay, $clientOkay)
                .environment(\.subscribeTask, $subscribeTask)
                .environment(\.gameStatus, $gameStatus)
                .environment(\.gameCode, $gameCode)
                .environment(\.worldID, $worldID)
                .environment(\.worldOneRegionID, $worldOneRegionID)
                .environment(\.worldOneStatus, $worldOneStatus)
                .environment(\.worldOneObject, $worldOneObject)
                .environment(\.worldOneAssignedStone, $worldOneAssignedStone)
                .environment(\.worldOneScore, $worldOneScore)
                .environment(\.initialDataStatus, $initialDataStatus)
                .environment(\.initialDataProcess, $initialDataProcess)
                .environment(\.initialDataWorldOneObjects, $initialDataWorldOneObjects)
                .environment(\.clientSettings, $clientSettings)
                .task {
                    do {
                        clientSettings = try await loadClientSettings()
                        let task = try await client
                            .setHost(clientSettings.host)
                            .setPort(clientSettings.port)
                            .setUseTLS(clientSettings.port == nil ? true : false)
                            .loadPublicKey(loadPublicKey)
                            .savePublicKey(savePublicKey)
                            .loadClientID(loadClientID)
                            .saveClientID(saveClientID)
                            .handleUpdate(processUpdate)
                            .prepareAndSubscribe()
                        clientOkay = true
                        subscribeTask = task
                        switch await task.result {
                        case .failure(let error):
                            throw error
                        default:
                            break
                        }
                    } catch {
                        clientOkay = false
                    }
                }
                .onChange(of: clientOkay, clientOkayChanged)
                .onChange(of: initialDataStatus, initialDataStatusChanged)
                .onChange(of: clientSettings, clientSettingsChanged)
                .onChange(of: scenePhase) { _, new in
                    switch new {
                    case .active:
                        do {
                            try audioManager.play("lumbay_bkg_music.m4a")
                        } catch {
                            print(error)
                        }
                    default:
                        audioManager.stop()
                    }
                }
        }
    }
}
