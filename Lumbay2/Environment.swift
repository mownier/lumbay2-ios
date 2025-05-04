import SwiftUI
import Lumbay2cl

struct ClientKey: EnvironmentKey {
    static var defaultValue: Lumbay2Client {
        return Lumbay2Client(host: "", port: nil, useTLS: false)
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

struct TestIntKey: EnvironmentKey {
    static let defaultValue: Binding<Int> = .constant(0)
}

extension EnvironmentValues {
    var testInt: Binding<Int> {
        set { self[TestIntKey.self] = newValue }
        get { self[TestIntKey.self] }
    }
}
