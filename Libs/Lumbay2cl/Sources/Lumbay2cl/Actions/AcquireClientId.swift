import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2

extension Lumbay2Client {
    
    @discardableResult
    public func acquireClientID() async throws -> Lumbay2Client {
        if !clientID.isEmpty {
            return self
        }
        let loadedClientID = try await loadClientID()
        print("loaded client id:", loadedClientID)
        if !loadedClientID.isEmpty {
            clientID = loadedClientID
            return self
        }
        let requestData = Lumbay2sv_AcquireClientIdRequest()
        var request = Lumbay2sv_Request()
        request.type = .acquireClientIDRequest(requestData)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .acquireClientIDReply(let replyData):
            clientID = replyData.clientID
            print("saved client id:", clientID)
            try await saveClientID(clientID)
        default:
            throw Errors.invalidReply
        }
        return self
    }
}
