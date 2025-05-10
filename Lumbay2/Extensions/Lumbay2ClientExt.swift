import SwiftUI
import Lumbay2cl

extension Lumbay2Client {
    
    func prepareAndSubscribe(_ okay: Binding<Bool>, _ task: Binding<Task<Void, Error>?>) async  {
        do {
            try await acquirePublicKey(name: "iOS").acquireClientID()
            okay.wrappedValue = true
        } catch {
            okay.wrappedValue = false
            return
        }
        task.wrappedValue = Task {
            do {
                try await subscribe()
            } catch  {
                okay.wrappedValue = false
            }
        }
    }
    
    func prepareAndSubscribe() async throws -> Task<Void, Error> {
        try await acquirePublicKey(name: "iOS").acquireClientID()
        return Task {
            do {
                try await subscribe()
            } catch  {
                throw error
            }
        }
    }
}
