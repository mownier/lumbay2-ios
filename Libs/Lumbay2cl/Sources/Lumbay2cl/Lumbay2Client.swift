import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2

public actor Lumbay2Client {
    var publicKey: String
    var clientID: String
    
    let host: String
    let port: Int?
    let useTLS: Bool
    
    public init(host: String, port: Int?, useTLS: Bool) {
        self.host = host
        self.port = port
        self.useTLS = useTLS
        self.publicKey = UserDefaults.standard.string(forKey: "Lumbay2Client.publicKey") ?? ""
        self.clientID = UserDefaults.standard.string(forKey: "Lumbay2Client.clientID") ?? ""
    }
    
    public func isPrepared() -> Bool {
        return !publicKey.isEmpty && !clientID.isEmpty
    }
    
    func createMetadata() -> Metadata {
        var metadata = Metadata()
        if let data = publicKey.data(using: .utf8) {
            metadata.addBinary(([UInt8])(data), forKey: "public_key-bin")
        }
        if let data = clientID.data(using: .utf8) {
            metadata.addBinary(([UInt8])(data), forKey: "client_id-bin")
        }
        return metadata
    }
    
    func createClient(_ block: (Lumbay2sv_LumbayLumbay.Client<HTTP2ClientTransport.Posix>) async throws -> Void) async throws {
        try await withGRPCClient(
            transport: .http2NIOPosix(
                target: .dns(host: host, port: port),
                transportSecurity: useTLS ? .tls : .plaintext
            ),
            handleClient: { client in
                try await block(Lumbay2sv_LumbayLumbay.Client(wrapping: client))
            }
        )
    }
    
    func sendRequest(_ request: Lumbay2sv_Request) async throws -> Lumbay2sv_Reply {
        var reply: Lumbay2sv_Reply?
        try await createClient { client in
            var callOptions = CallOptions.defaults
            callOptions.timeout = .seconds(10)
            reply = try await client.sendRequest(
                request,
                metadata: createMetadata()
            )
        }
        if let result = reply {
            return result
        }
        throw Errors.replyIsNil
    }
    
    public enum Errors: Error {
        case unimplemented
        case invalidReply
        case replyIsNil
    }
}
