import Testing
@testable import Lumbay2cl

@Test func example() async throws {
    let client = Lumbay2Client(host: "nirs-air.", port: 50052)
    try await client.acquirePublicKey(name: "iOS")
    try await client.acquireClientID()
}
