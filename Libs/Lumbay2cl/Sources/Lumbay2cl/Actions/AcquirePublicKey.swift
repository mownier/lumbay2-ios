import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2

extension Lumbay2Client {
    
    @discardableResult
    public func acquirePublicKey(name: String) async throws -> Lumbay2Client {
        if !publicKey.isEmpty {
            return self
        }
        let loadedPublicKey = try await loadPublicKey()
        if !loadedPublicKey.isEmpty {
            publicKey = loadedPublicKey
            return self
        }
        var requestData = Lumbay2sv_AcquirePublicKeyRequest()
        requestData.name = name
        var request = Lumbay2sv_Request()
        request.type = .acquirePublicKeyRequest(requestData)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .acquirePublicKeyReply(let replyData):
            publicKey = replyData.publicKey
            try await savePublicKey(publicKey)
        default:
            throw Errors.invalidReply
        }
        return self
    }
}
