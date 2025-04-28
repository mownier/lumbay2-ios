import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2

extension Lumbay2Client {
    
    public func acquireClientID() async throws {
        let requestData = Lumbay2sv_AcquireClientIdRequest()
        var request = Lumbay2sv_Request()
        request.type = .acquireClientIDRequest(requestData)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .acquireClientIDReply(let replyData):
            clientID = replyData.clientID
            UserDefaults.standard.set(clientID, forKey: "Lumbay2Client.clientID")
        default:
            throw Errors.invalidReply
        }
    }
}
