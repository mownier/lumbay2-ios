extension Lumbay2Client {
    
    public func createGame() async throws {
        let data = Lumbay2sv_CreateGameRequest()
        var request = Lumbay2sv_Request()
        request.type = .createGameRequest(data)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .createGameReply:
            break
        default:
            throw Errors.invalidReply
        }
    }
}
