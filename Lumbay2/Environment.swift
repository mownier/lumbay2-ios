import SwiftUI
import Lumbay2cl

struct ClientKey: EnvironmentKey {
    static var defaultValue: Lumbay2Client {
        return Lumbay2Client()
    }
}

extension EnvironmentValues {
    var client: Lumbay2Client {
        set { self[ClientKey.self] = newValue }
        get { self[ClientKey.self] }
    }
}

struct ClientOkayKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var clientOkay: Binding<Bool> {
        set { self[ClientOkayKey.self] = newValue }
        get { self[ClientOkayKey.self] }
    }
}

struct SubscribeTaskKey: EnvironmentKey {
    static let defaultValue: Binding<Task<Void, Error>?> = .constant(nil)
}

extension EnvironmentValues {
    var subscribeTask: Binding<Task<Void, Error>?> {
        set { self[SubscribeTaskKey.self] = newValue }
        get { self[SubscribeTaskKey.self] }
    }
}

struct GameStatusKey: EnvironmentKey {
    static let defaultValue: Binding<Lumbay2sv_GameStatus> = .constant(.none)
}

extension EnvironmentValues {
    var gameStatus: Binding<Lumbay2sv_GameStatus> {
        set { self[GameStatusKey.self] = newValue }
        get { self[GameStatusKey.self] }
    }
}

struct GameCodeKey: EnvironmentKey {
    static let defaultValue: Binding<String> = .constant("")
}

extension EnvironmentValues {
    var gameCode: Binding<String> {
        set { self[GameCodeKey.self] = newValue }
        get { self[GameCodeKey.self] }
    }
}

struct WorldIDKey: EnvironmentKey {
    static let defaultValue: Binding<Lumbay2sv_WorldId> = .constant(.none)
}

extension EnvironmentValues {
    var worldID: Binding<Lumbay2sv_WorldId> {
        set { self[WorldIDKey.self] = newValue }
        get { self[WorldIDKey.self] }
    }
}

struct WorldOneRegionIDKey: EnvironmentKey {
    static let defaultValue: Binding<Lumbay2sv_WorldOneRegionId> = .constant(.none)
}

extension EnvironmentValues {
    var worldOneRegionID: Binding<Lumbay2sv_WorldOneRegionId> {
        set { self[WorldOneRegionIDKey.self] = newValue }
        get { self[WorldOneRegionIDKey.self] }
    }
}

struct WorldOneStatusKey: EnvironmentKey {
    static let defaultValue: Binding<Lumbay2sv_WorldOneStatus> = .constant(.none)
}

extension EnvironmentValues {
    var worldOneStatus: Binding<Lumbay2sv_WorldOneStatus> {
        set { self[WorldOneStatusKey.self] = newValue }
        get { self[WorldOneStatusKey.self] }
    }
}

struct WorldOneObjectKey: EnvironmentKey {
    static let defaultValue: Binding<Lumbay2sv_WorldOneObject?> = .constant(nil)
}

extension EnvironmentValues {
    var worldOneObject: Binding<Lumbay2sv_WorldOneObject?> {
        set { self[WorldOneObjectKey.self] = newValue }
        get { self[WorldOneObjectKey.self] }
    }
}

struct WorldOneAssignedStoneKey: EnvironmentKey {
    static let defaultValue: Binding<WorldOneAssignedStone> = .constant(.none)
}

extension EnvironmentValues {
    var worldOneAssignedStone: Binding<WorldOneAssignedStone> {
        set { self[WorldOneAssignedStoneKey.self] = newValue }
        get { self[WorldOneAssignedStoneKey.self] }
    }
}

struct WorldOneScoreKey: EnvironmentKey {
    static let defaultValue: Binding<Lumbay2sv_WorldOneScore> = .constant(Lumbay2sv_WorldOneScore())
}

extension EnvironmentValues {
    var worldOneScore: Binding<Lumbay2sv_WorldOneScore> {
        set { self[WorldOneScoreKey.self] = newValue }
        get { self[WorldOneScoreKey.self] }
    }
}

struct InitialDataStatusKey: EnvironmentKey {
    static let defaultValue: Binding<Lumbay2sv_InitialDataStatus> = .constant(.none)
}

extension EnvironmentValues {
    var initialDataStatus: Binding<Lumbay2sv_InitialDataStatus> {
        set { self[InitialDataStatusKey.self] = newValue }
        get { self[InitialDataStatusKey.self] }
    }
}

struct InitialDataProcessKey: EnvironmentKey {
    static let defaultValue: Binding<InitialDataProcess> = .constant(.none)
}

extension EnvironmentValues {
    var initialDataProcess: Binding<InitialDataProcess> {
        set { self[InitialDataProcessKey.self] = newValue }
        get { self[InitialDataProcessKey.self] }
    }
}

struct InitialDataWorldOneObjectsKey: EnvironmentKey {
    static let defaultValue: Binding<[Lumbay2sv_WorldOneObject]> = .constant([])
}

extension EnvironmentValues {
    var initialDataWorldOneObjects: Binding<[Lumbay2sv_WorldOneObject]> {
        set { self[InitialDataWorldOneObjectsKey.self] = newValue }
        get { self[InitialDataWorldOneObjectsKey.self] }
    }
}

struct ClientSettingsKey: EnvironmentKey {
    static let defaultValue: Binding<ClientSettings> = .constant(ClientSettings())
}

extension EnvironmentValues {
    var clientSettings: Binding<ClientSettings> {
        set { self[ClientSettingsKey.self] = newValue }
        get { self[ClientSettingsKey.self] }
    }
}
