extension Lumbay2Client {
    
    public func processWorldOneObject(_ data: Lumbay2sv_ProcessWorldOneObjectRequest) async throws {
        var request = Lumbay2sv_Request()
        request.type = .processWorldOneObjectRequest(data)
        let reply = try await sendRequest(request)
        switch reply.type {
        case .processWorldOneObjectReply:
            break
        default:
            throw Errors.invalidReply
        }
    }
}
