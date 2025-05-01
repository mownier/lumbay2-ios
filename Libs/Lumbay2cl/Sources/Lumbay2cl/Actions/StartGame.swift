extension Lumbay2Client {
    
    public func startGame() async throws {
        let data = Lumbay2sv_StartGameRequest()
        var request = Lumbay2sv_Request()
        request.type = .startGameRequest(data)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .startGameReply:
            break
        default:
            throw Errors.invalidReply
        }
    }
}
