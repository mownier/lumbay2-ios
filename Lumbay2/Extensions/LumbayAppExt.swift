import SwiftUI
import Lumbay2cl

extension Lumbay2App {
    
    var publicKeyUserInfoKey: String { "\(userDefaultsPrefixKey)Lumbay2Client.publicKey" }
    var clientIDUserInfoKey: String { "\(userDefaultsPrefixKey)Lumbay2Client.clientID" }
    
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
        switch update.type {
        case .readyToStartUpdate(_):
            gameStatus = .readyToStart
        case .waitingForOtherPlayerUpdate(_):
            gameStatus = .waitingForOtherPlayer
        case .youAreInGameUpdate(_):
            gameStatus = .started
        case .gameCodeGenerated(let data):
            gameCode = data.gameCode
        default:
            break
        }
    }
}
