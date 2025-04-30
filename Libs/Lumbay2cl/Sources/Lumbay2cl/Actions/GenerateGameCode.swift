extension Lumbay2Client {
    
    public func generateGameCode() async throws {
        let data = Lumbay2sv_GenerateGameCodeRequest()
        var request = Lumbay2sv_Request()
        request.type = .generateGameCodeRequest(data)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .generateGameCodeReply:
            break
        default:
            throw Errors.invalidReply
        }
    }
}
