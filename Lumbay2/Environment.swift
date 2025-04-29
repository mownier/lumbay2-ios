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
