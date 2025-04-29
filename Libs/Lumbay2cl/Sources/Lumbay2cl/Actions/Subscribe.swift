import GRPCCore

extension Lumbay2Client {
    
    public func subscribe() async throws {
        try await createClient { client in
            try await client.subscribe(Lumbay2sv_Empty(), metadata: createMetadata()) { [weak self] stream in
                for try await update in stream.messages {
                    if Task.isCancelled {
                        throw CancellationError()
                    }
                    try await self?.handleUpdate?(update)
                }
            }
        }
    }
}
