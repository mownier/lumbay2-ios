extension Lumbay2Client {

    public func quitGame() async throws {
        let data = Lumbay2sv_QuitGameRequest()
        var request = Lumbay2sv_Request()
        request.type = .quitGameRequest(data)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .quitGameReply:
            break
        default:
            throw Errors.invalidReply
        }
    }
}
