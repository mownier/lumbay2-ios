import SwiftUI
import Lumbay2cl

extension Lumbay2App {
    
    var publicKeyUserInfoKey: String { "Lumbay2Client.publicKey" }
    var clientIDUserInfoKey: String { "Lumbay2Client.clientID" }

    var clientSettingsHostUserInfoKey: String { "Lumbay2Client.clientSettingsHost" }
    var clientSettingsPortUserInfoKey: String { "Lumbay2Client.clientSettingsPort" }
    
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
    
    func loadClientSettings() async throws -> ClientSettings {
        var settings = ClientSettings()
        settings.host = UserDefaults.standard.string(forKey: clientSettingsHostUserInfoKey) ?? ""
        settings.port = UserDefaults.standard.object(forKey: clientSettingsPortUserInfoKey) as? Int
        return settings
    }
    
    func saveClientSettings(host: String, port: Int?) async throws {
        UserDefaults.standard.setValue(host, forKey: clientSettingsHostUserInfoKey)
        UserDefaults.standard.setValue(port, forKey: clientSettingsPortUserInfoKey)
    }
    
    @Sendable func processUpdate(_ update: Lumbay2sv_Update) async throws {
        switch initialDataStatus {
        case .none, .started, .UNRECOGNIZED:
            switch update.type {
            case .initialDataUpdate(let data):
                initialDataStatus = data.status
            default:
                initialUpdates.append(update)
            }
            return
        case .ended:
            break
        }
        handleUpdate(update)
    }
    
    func handleUpdate(_ update: Lumbay2sv_Update) {
        switch update.type {
        case .gameStatusUpdate(let data):
            gameStatus = data.status
        case .gameCodeGenerated(let data):
            gameCode = data.gameCode
        case .worldOneRegionUpdate(let data):
            worldID = Lumbay2sv_WorldId.one
            worldOneRegionID = data.regionID
        case .worldOneObjectUpdate(let data):
            if worldID != Lumbay2sv_WorldId.one || worldOneRegionID != data.regionID {
                break
            }
            if data.objectStatus == .assigned {
                switch data.objectID {
                case .stonePlayerOne:
                    worldOneAssignedStone = .playerOneStone
                case .stonePlayerTwo:
                    worldOneAssignedStone = .playerTwoStone
                default:
                    break
                }
                break
            }
            var obj = Lumbay2sv_WorldOneObject()
            obj.id = data.objectID
            obj.status = data.objectStatus
            obj.data = data.objectData
            worldOneObject = obj
        case .worldOneStatusUpdate(let data):
            if worldID != Lumbay2sv_WorldId.one || worldOneRegionID != data.regionID {
                break
            }
            worldOneStatus = data.status
        case .worldOneScoreUpdate(let data):
            if worldID != Lumbay2sv_WorldId.one || worldOneRegionID != data.score.regionID {
                break
            }
            worldOneScore = data.score
        default:
            break
        }
    }
    
    func clientOkayChanged(
        _ oldValue: Bool,
        _ newValue: Bool
    ) {
        if newValue {
            return
        }
        initialDataStatus = .none
        initialDataProcess = .none
    }
    
    func initialDataStatusChanged(
        _ oldValue: Lumbay2sv_InitialDataStatus,
        _ newValue: Lumbay2sv_InitialDataStatus
    ) {
        if newValue != .ended {
            return
        }
        initialDataWorldOneObjects.removeAll()
        initialDataProcess = .started
        for update in initialUpdates {
            handleUpdate(update)
            switch update.type {
            case .worldOneObjectUpdate(let data):
                if data.objectStatus == .assigned {
                    switch data.objectID {
                    case .stonePlayerOne:
                        worldOneAssignedStone = .playerOneStone
                    case .stonePlayerTwo:
                        worldOneAssignedStone = .playerTwoStone
                    default:
                        break
                    }
                    break
                }
                var obj = Lumbay2sv_WorldOneObject()
                obj.id = data.objectID
                obj.status = data.objectStatus
                obj.data = data.objectData
                initialDataWorldOneObjects.append(obj)
            default:
                break
            }
        }
        initialUpdates.removeAll()
        initialDataProcess = .ended
    }
    
    func clientSettingsChanged(_ old: ClientSettings, _ new: ClientSettings) {
        Task {
            try? await saveClientSettings(host: new.host, port: new.port)
        }
    }
}

struct ClientSettings: Equatable {
    var host: String = ""
    var port: Int? = nil
    static func == (lhs: ClientSettings, rhs: ClientSettings) -> Bool {
        return  lhs.host == rhs.host && lhs.port == rhs.port
    }
}
