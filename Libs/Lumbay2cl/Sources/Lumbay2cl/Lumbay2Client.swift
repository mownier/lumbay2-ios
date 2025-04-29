import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2
import NIO

public actor Lumbay2Client {
    var publicKey: String
    var clientID: String
    
    let host: String
    let port: Int?
    let useTLS: Bool
    
    var nullableSavePublicKey: ((String) async throws -> Void)?
    var nullableLoadPublicKey: (() async throws -> String)?
    var nullableSaveClientID: ((String) async throws -> Void)?
    var nullableLoadClientID: (() async throws -> String)?
    
    var handleUpdate: (@Sendable (Lumbay2sv_Update) async throws -> Void)?
    
    public init(host: String, port: Int?, useTLS: Bool) {
        self.host = host
        self.port = port
        self.useTLS = useTLS
        self.publicKey = ""
        self.clientID = ""
    }
    
    @discardableResult
    public func loadPublicKey(_ handler: (() async throws -> String)?) -> Lumbay2Client {
        nullableLoadPublicKey = handler
        return self
    }
    
    @discardableResult
    public func savePublicKey(_ handler: ((String) async throws -> Void)?) -> Lumbay2Client {
        nullableSavePublicKey = handler
        return self
    }
    
    @discardableResult
    public func loadClientID(_ handler: (() async throws -> String)?) -> Lumbay2Client {
        nullableLoadClientID = handler
        return self
    }
    
    @discardableResult
    public func saveClientID(_ handler: ((String) async throws -> Void)?) -> Lumbay2Client {
        nullableSaveClientID = handler
        return self
    }
    
    @discardableResult
    public func handleUpdate(_ handler: (@Sendable (Lumbay2sv_Update) async throws -> Void)?) -> Lumbay2Client {
        handleUpdate = handler
        return self
    }
    
    func savePublicKey(_ value: String) async throws {
        if let handler = nullableSavePublicKey {
            try await handler(value)
            return
        }
        throw Errors.noHandlerForSavingPublicKey
    }
    
    func loadPublicKey() async throws -> String {
        if let handler = nullableLoadPublicKey {
            return try await handler()
        }
        throw Errors.noHandlerForLoadingPublicKey
    }
    
    func saveClientID(_ value: String) async throws {
        if let handler = nullableSaveClientID {
            try await handler(value)
            return
        }
        throw Errors.noHandlerForSavingClientID
    }
    
    func loadClientID() async throws -> String {
        if let handler = nullableLoadClientID {
            return try await handler()
        }
        throw Errors.noHandlerForLoadingClientID
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
        case noHandlerForSavingPublicKey
        case noHandlerForLoadingPublicKey
        case noHandlerForSavingClientID
        case noHandlerForLoadingClientID
    }
}
