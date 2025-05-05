extension Lumbay2Client {
    
    public func restartWorld() async throws {
        let data = Lumbay2sv_RestartWorldRequest()
        var request = Lumbay2sv_Request()
        request.type = .restartWorldRequest(data)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .restartWorldReply:
            break
        default:
            throw Errors.invalidReply
        }
    }
}
