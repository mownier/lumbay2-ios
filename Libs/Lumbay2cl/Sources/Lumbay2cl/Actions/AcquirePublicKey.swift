import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2

extension Lumbay2Client {
    
    public func acquirePublicKey(name: String) async throws {
        var requestData = Lumbay2sv_AcquirePublicKeyRequest()
        requestData.name = name
        var request = Lumbay2sv_Request()
        request.type = .acquirePublicKeyRequest(requestData)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .acquirePublicKeyReply(let replyData):
            publicKey = replyData.publicKey
            UserDefaults.standard.set(publicKey, forKey: "Lumbay2Client.publicKey")
        default:
            throw Errors.invalidReply
        }
    }
}
