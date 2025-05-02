import SwiftUI
import Lumbay2cl

extension Lumbay2App {
    
    var publicKeyUserInfoKey: String { "Lumbay2Client.publicKey" }
    var clientIDUserInfoKey: String { "Lumbay2Client.clientID" }
    
    func loadPublicKey() async throws -> String {
        return UserDefaults.standard.string(forKey: publicKeyUserInfoKey) ?? ""
    }
    
    func savePublicKey(_ value: String) async throws {
        UserDefaults.standard.setValue(value, forKey: publicKeyUserInfoKey)
    }
    
    func loadClientID() async throws -> String {
        return UserDefaults.standard.string(forKey: clientIDUserInfoKey) ?? ""
    }
    
    func saveClientID(_ value: String) async throws {
        UserDefaults.standard.setValue(value, forKey: clientIDUserInfoKey)
    }
    
    @Sendable func processUpdate(_ update: Lumbay2sv_Update) async throws {
        print(update)
        switch update.type {
        case .readyToStartUpdate:
            gameStatus = .readyToStart
        case .waitingForOtherPlayerUpdate:
            gameStatus = .waitingForOtherPlayer
        case .youAreInGameUpdate:
            gameStatus = .started
        case .gameCodeGenerated(let data):
            gameCode = data.gameCode
        case .youQuitTheGameUpdate:
            gameStatus = .none
        case .gameStartedUpdate:
            gameStatus = .started
        case .worldUpdate(let data):
            world = data.world
        default:
            break
        }
    }
}
