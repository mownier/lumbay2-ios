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

struct UserDefaultsPrefixKeyKey: EnvironmentKey {
    static let defaultValue: String = ""
}

extension EnvironmentValues {
    var userDefaultsPrefixKey: String {
        set { self[UserDefaultsPrefixKeyKey.self] = newValue }
        get { self[UserDefaultsPrefixKeyKey.self] }
    }
}
