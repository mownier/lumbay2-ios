extension Lumbay2Client {
    
    public func joinGame(gameCode: String) async throws {
        var data = Lumbay2sv_JoinGameRequest()
        data.gameCode = gameCode
        var request = Lumbay2sv_Request()
        request.type = .joinGameRequest(data)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .joinGameReply:
            break
        default:
            throw Errors.invalidReply
        }
    }
}
