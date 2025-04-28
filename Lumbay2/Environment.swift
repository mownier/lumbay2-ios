import SwiftUI
import Lumbay2cl

struct Lumbay2ClientKey: EnvironmentKey {
    static var defaultValue: Lumbay2Client {
        return Lumbay2Client(host: "", port: nil, useTLS: false)
    }
}

extension EnvironmentValues {
    var lumbay2Client: Lumbay2Client {
        set { self[Lumbay2ClientKey.self] = newValue }
        get { self[Lumbay2ClientKey.self] }
    }
}
