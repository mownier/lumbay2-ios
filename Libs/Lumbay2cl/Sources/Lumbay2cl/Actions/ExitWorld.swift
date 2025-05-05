extension Lumbay2Client {
    
    public func exitWorld() async throws {
        let data = Lumbay2sv_ExitWorldRequest()
        var request = Lumbay2sv_Request()
        request.type = .exitWorldRequest(data)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .exitWorldReply:
            break
        default:
            throw Errors.invalidReply
        }
    }
}
