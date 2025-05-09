// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the gRPC Swift generator plugin for the protocol buffer compiler.
// Source: Libs/Lumbay2cl/Sources/Lumbay2cl/lumbay2.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/grpc/grpc-swift

import GRPCCore
import GRPCProtobuf

// MARK: - lumbay2sv.LumbayLumbay

/// Namespace containing generated types for the "lumbay2sv.LumbayLumbay" service.
internal enum Lumbay2sv_LumbayLumbay {
    /// Service descriptor for the "lumbay2sv.LumbayLumbay" service.
    internal static let descriptor = GRPCCore.ServiceDescriptor(fullyQualifiedService: "lumbay2sv.LumbayLumbay")
    /// Namespace for method metadata.
    internal enum Method {
        /// Namespace for "SendRequest" metadata.
        internal enum SendRequest {
            /// Request type for "SendRequest".
            internal typealias Input = Lumbay2sv_Request
            /// Response type for "SendRequest".
            internal typealias Output = Lumbay2sv_Reply
            /// Descriptor for "SendRequest".
            internal static let descriptor = GRPCCore.MethodDescriptor(
                service: GRPCCore.ServiceDescriptor(fullyQualifiedService: "lumbay2sv.LumbayLumbay"),
                method: "SendRequest"
            )
        }
        /// Namespace for "Subscribe" metadata.
        internal enum Subscribe {
            /// Request type for "Subscribe".
            internal typealias Input = Lumbay2sv_Empty
            /// Response type for "Subscribe".
            internal typealias Output = Lumbay2sv_Update
            /// Descriptor for "Subscribe".
            internal static let descriptor = GRPCCore.MethodDescriptor(
                service: GRPCCore.ServiceDescriptor(fullyQualifiedService: "lumbay2sv.LumbayLumbay"),
                method: "Subscribe"
            )
        }
        /// Descriptors for all methods in the "lumbay2sv.LumbayLumbay" service.
        internal static let descriptors: [GRPCCore.MethodDescriptor] = [
            SendRequest.descriptor,
            Subscribe.descriptor
        ]
    }
}

extension GRPCCore.ServiceDescriptor {
    /// Service descriptor for the "lumbay2sv.LumbayLumbay" service.
    internal static let lumbay2Sv_LumbayLumbay = GRPCCore.ServiceDescriptor(fullyQualifiedService: "lumbay2sv.LumbayLumbay")
}

// MARK: lumbay2sv.LumbayLumbay (server)

extension Lumbay2sv_LumbayLumbay {
    /// Streaming variant of the service protocol for the "lumbay2sv.LumbayLumbay" service.
    ///
    /// This protocol is the lowest-level of the service protocols generated for this service
    /// giving you the most flexibility over the implementation of your service. This comes at
    /// the cost of more verbose and less strict APIs. Each RPC requires you to implement it in
    /// terms of a request stream and response stream. Where only a single request or response
    /// message is expected, you are responsible for enforcing this invariant is maintained.
    ///
    /// Where possible, prefer using the stricter, less-verbose ``ServiceProtocol``
    /// or ``SimpleServiceProtocol`` instead.
    internal protocol StreamingServiceProtocol: GRPCCore.RegistrableRPCService {
        /// Handle the "SendRequest" method.
        ///
        /// - Parameters:
        ///   - request: A streaming request of `Lumbay2sv_Request` messages.
        ///   - context: Context providing information about the RPC.
        /// - Throws: Any error which occurred during the processing of the request. Thrown errors
        ///     of type `RPCError` are mapped to appropriate statuses. All other errors are converted
        ///     to an internal error.
        /// - Returns: A streaming response of `Lumbay2sv_Reply` messages.
        func sendRequest(
            request: GRPCCore.StreamingServerRequest<Lumbay2sv_Request>,
            context: GRPCCore.ServerContext
        ) async throws -> GRPCCore.StreamingServerResponse<Lumbay2sv_Reply>

        /// Handle the "Subscribe" method.
        ///
        /// - Parameters:
        ///   - request: A streaming request of `Lumbay2sv_Empty` messages.
        ///   - context: Context providing information about the RPC.
        /// - Throws: Any error which occurred during the processing of the request. Thrown errors
        ///     of type `RPCError` are mapped to appropriate statuses. All other errors are converted
        ///     to an internal error.
        /// - Returns: A streaming response of `Lumbay2sv_Update` messages.
        func subscribe(
            request: GRPCCore.StreamingServerRequest<Lumbay2sv_Empty>,
            context: GRPCCore.ServerContext
        ) async throws -> GRPCCore.StreamingServerResponse<Lumbay2sv_Update>
    }

    /// Service protocol for the "lumbay2sv.LumbayLumbay" service.
    ///
    /// This protocol is higher level than ``StreamingServiceProtocol`` but lower level than
    /// the ``SimpleServiceProtocol``, it provides access to request and response metadata and
    /// trailing response metadata. If you don't need these then consider using
    /// the ``SimpleServiceProtocol``. If you need fine grained control over your RPCs then
    /// use ``StreamingServiceProtocol``.
    internal protocol ServiceProtocol: Lumbay2sv_LumbayLumbay.StreamingServiceProtocol {
        /// Handle the "SendRequest" method.
        ///
        /// - Parameters:
        ///   - request: A request containing a single `Lumbay2sv_Request` message.
        ///   - context: Context providing information about the RPC.
        /// - Throws: Any error which occurred during the processing of the request. Thrown errors
        ///     of type `RPCError` are mapped to appropriate statuses. All other errors are converted
        ///     to an internal error.
        /// - Returns: A response containing a single `Lumbay2sv_Reply` message.
        func sendRequest(
            request: GRPCCore.ServerRequest<Lumbay2sv_Request>,
            context: GRPCCore.ServerContext
        ) async throws -> GRPCCore.ServerResponse<Lumbay2sv_Reply>

        /// Handle the "Subscribe" method.
        ///
        /// - Parameters:
        ///   - request: A request containing a single `Lumbay2sv_Empty` message.
        ///   - context: Context providing information about the RPC.
        /// - Throws: Any error which occurred during the processing of the request. Thrown errors
        ///     of type `RPCError` are mapped to appropriate statuses. All other errors are converted
        ///     to an internal error.
        /// - Returns: A streaming response of `Lumbay2sv_Update` messages.
        func subscribe(
            request: GRPCCore.ServerRequest<Lumbay2sv_Empty>,
            context: GRPCCore.ServerContext
        ) async throws -> GRPCCore.StreamingServerResponse<Lumbay2sv_Update>
    }

    /// Simple service protocol for the "lumbay2sv.LumbayLumbay" service.
    ///
    /// This is the highest level protocol for the service. The API is the easiest to use but
    /// doesn't provide access to request or response metadata. If you need access to these
    /// then use ``ServiceProtocol`` instead.
    internal protocol SimpleServiceProtocol: Lumbay2sv_LumbayLumbay.ServiceProtocol {
        /// Handle the "SendRequest" method.
        ///
        /// - Parameters:
        ///   - request: A `Lumbay2sv_Request` message.
        ///   - context: Context providing information about the RPC.
        /// - Throws: Any error which occurred during the processing of the request. Thrown errors
        ///     of type `RPCError` are mapped to appropriate statuses. All other errors are converted
        ///     to an internal error.
        /// - Returns: A `Lumbay2sv_Reply` to respond with.
        func sendRequest(
            request: Lumbay2sv_Request,
            context: GRPCCore.ServerContext
        ) async throws -> Lumbay2sv_Reply

        /// Handle the "Subscribe" method.
        ///
        /// - Parameters:
        ///   - request: A `Lumbay2sv_Empty` message.
        ///   - response: A response stream of `Lumbay2sv_Update` messages.
        ///   - context: Context providing information about the RPC.
        /// - Throws: Any error which occurred during the processing of the request. Thrown errors
        ///     of type `RPCError` are mapped to appropriate statuses. All other errors are converted
        ///     to an internal error.
        func subscribe(
            request: Lumbay2sv_Empty,
            response: GRPCCore.RPCWriter<Lumbay2sv_Update>,
            context: GRPCCore.ServerContext
        ) async throws
    }
}

// Default implementation of 'registerMethods(with:)'.
extension Lumbay2sv_LumbayLumbay.StreamingServiceProtocol {
    internal func registerMethods<Transport>(with router: inout GRPCCore.RPCRouter<Transport>) where Transport: GRPCCore.ServerTransport {
        router.registerHandler(
            forMethod: Lumbay2sv_LumbayLumbay.Method.SendRequest.descriptor,
            deserializer: GRPCProtobuf.ProtobufDeserializer<Lumbay2sv_Request>(),
            serializer: GRPCProtobuf.ProtobufSerializer<Lumbay2sv_Reply>(),
            handler: { request, context in
                try await self.sendRequest(
                    request: request,
                    context: context
                )
            }
        )
        router.registerHandler(
            forMethod: Lumbay2sv_LumbayLumbay.Method.Subscribe.descriptor,
            deserializer: GRPCProtobuf.ProtobufDeserializer<Lumbay2sv_Empty>(),
            serializer: GRPCProtobuf.ProtobufSerializer<Lumbay2sv_Update>(),
            handler: { request, context in
                try await self.subscribe(
                    request: request,
                    context: context
                )
            }
        )
    }
}

// Default implementation of streaming methods from 'StreamingServiceProtocol'.
extension Lumbay2sv_LumbayLumbay.ServiceProtocol {
    internal func sendRequest(
        request: GRPCCore.StreamingServerRequest<Lumbay2sv_Request>,
        context: GRPCCore.ServerContext
    ) async throws -> GRPCCore.StreamingServerResponse<Lumbay2sv_Reply> {
        let response = try await self.sendRequest(
            request: GRPCCore.ServerRequest(stream: request),
            context: context
        )
        return GRPCCore.StreamingServerResponse(single: response)
    }

    internal func subscribe(
        request: GRPCCore.StreamingServerRequest<Lumbay2sv_Empty>,
        context: GRPCCore.ServerContext
    ) async throws -> GRPCCore.StreamingServerResponse<Lumbay2sv_Update> {
        let response = try await self.subscribe(
            request: GRPCCore.ServerRequest(stream: request),
            context: context
        )
        return response
    }
}

// Default implementation of methods from 'ServiceProtocol'.
extension Lumbay2sv_LumbayLumbay.SimpleServiceProtocol {
    internal func sendRequest(
        request: GRPCCore.ServerRequest<Lumbay2sv_Request>,
        context: GRPCCore.ServerContext
    ) async throws -> GRPCCore.ServerResponse<Lumbay2sv_Reply> {
        return GRPCCore.ServerResponse<Lumbay2sv_Reply>(
            message: try await self.sendRequest(
                request: request.message,
                context: context
            ),
            metadata: [:]
        )
    }

    internal func subscribe(
        request: GRPCCore.ServerRequest<Lumbay2sv_Empty>,
        context: GRPCCore.ServerContext
    ) async throws -> GRPCCore.StreamingServerResponse<Lumbay2sv_Update> {
        return GRPCCore.StreamingServerResponse<Lumbay2sv_Update>(
            metadata: [:],
            producer: { writer in
                try await self.subscribe(
                    request: request.message,
                    response: writer,
                    context: context
                )
                return [:]
            }
        )
    }
}

// MARK: lumbay2sv.LumbayLumbay (client)

extension Lumbay2sv_LumbayLumbay {
    /// Generated client protocol for the "lumbay2sv.LumbayLumbay" service.
    ///
    /// You don't need to implement this protocol directly, use the generated
    /// implementation, ``Client``.
    internal protocol ClientProtocol: Sendable {
        /// Call the "SendRequest" method.
        ///
        /// - Parameters:
        ///   - request: A request containing a single `Lumbay2sv_Request` message.
        ///   - serializer: A serializer for `Lumbay2sv_Request` messages.
        ///   - deserializer: A deserializer for `Lumbay2sv_Reply` messages.
        ///   - options: Options to apply to this RPC.
        ///   - handleResponse: A closure which handles the response, the result of which is
        ///       returned to the caller. Returning from the closure will cancel the RPC if it
        ///       hasn't already finished.
        /// - Returns: The result of `handleResponse`.
        func sendRequest<Result>(
            request: GRPCCore.ClientRequest<Lumbay2sv_Request>,
            serializer: some GRPCCore.MessageSerializer<Lumbay2sv_Request>,
            deserializer: some GRPCCore.MessageDeserializer<Lumbay2sv_Reply>,
            options: GRPCCore.CallOptions,
            onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Lumbay2sv_Reply>) async throws -> Result
        ) async throws -> Result where Result: Sendable

        /// Call the "Subscribe" method.
        ///
        /// - Parameters:
        ///   - request: A request containing a single `Lumbay2sv_Empty` message.
        ///   - serializer: A serializer for `Lumbay2sv_Empty` messages.
        ///   - deserializer: A deserializer for `Lumbay2sv_Update` messages.
        ///   - options: Options to apply to this RPC.
        ///   - handleResponse: A closure which handles the response, the result of which is
        ///       returned to the caller. Returning from the closure will cancel the RPC if it
        ///       hasn't already finished.
        /// - Returns: The result of `handleResponse`.
        func subscribe<Result>(
            request: GRPCCore.ClientRequest<Lumbay2sv_Empty>,
            serializer: some GRPCCore.MessageSerializer<Lumbay2sv_Empty>,
            deserializer: some GRPCCore.MessageDeserializer<Lumbay2sv_Update>,
            options: GRPCCore.CallOptions,
            onResponse handleResponse: @Sendable @escaping (GRPCCore.StreamingClientResponse<Lumbay2sv_Update>) async throws -> Result
        ) async throws -> Result where Result: Sendable
    }

    /// Generated client for the "lumbay2sv.LumbayLumbay" service.
    ///
    /// The ``Client`` provides an implementation of ``ClientProtocol`` which wraps
    /// a `GRPCCore.GRPCCClient`. The underlying `GRPCClient` provides the long-lived
    /// means of communication with the remote peer.
    internal struct Client<Transport>: ClientProtocol where Transport: GRPCCore.ClientTransport {
        private let client: GRPCCore.GRPCClient<Transport>

        /// Creates a new client wrapping the provided `GRPCCore.GRPCClient`.
        ///
        /// - Parameters:
        ///   - client: A `GRPCCore.GRPCClient` providing a communication channel to the service.
        internal init(wrapping client: GRPCCore.GRPCClient<Transport>) {
            self.client = client
        }

        /// Call the "SendRequest" method.
        ///
        /// - Parameters:
        ///   - request: A request containing a single `Lumbay2sv_Request` message.
        ///   - serializer: A serializer for `Lumbay2sv_Request` messages.
        ///   - deserializer: A deserializer for `Lumbay2sv_Reply` messages.
        ///   - options: Options to apply to this RPC.
        ///   - handleResponse: A closure which handles the response, the result of which is
        ///       returned to the caller. Returning from the closure will cancel the RPC if it
        ///       hasn't already finished.
        /// - Returns: The result of `handleResponse`.
        internal func sendRequest<Result>(
            request: GRPCCore.ClientRequest<Lumbay2sv_Request>,
            serializer: some GRPCCore.MessageSerializer<Lumbay2sv_Request>,
            deserializer: some GRPCCore.MessageDeserializer<Lumbay2sv_Reply>,
            options: GRPCCore.CallOptions = .defaults,
            onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Lumbay2sv_Reply>) async throws -> Result = { response in
                try response.message
            }
        ) async throws -> Result where Result: Sendable {
            try await self.client.unary(
                request: request,
                descriptor: Lumbay2sv_LumbayLumbay.Method.SendRequest.descriptor,
                serializer: serializer,
                deserializer: deserializer,
                options: options,
                onResponse: handleResponse
            )
        }

        /// Call the "Subscribe" method.
        ///
        /// - Parameters:
        ///   - request: A request containing a single `Lumbay2sv_Empty` message.
        ///   - serializer: A serializer for `Lumbay2sv_Empty` messages.
        ///   - deserializer: A deserializer for `Lumbay2sv_Update` messages.
        ///   - options: Options to apply to this RPC.
        ///   - handleResponse: A closure which handles the response, the result of which is
        ///       returned to the caller. Returning from the closure will cancel the RPC if it
        ///       hasn't already finished.
        /// - Returns: The result of `handleResponse`.
        internal func subscribe<Result>(
            request: GRPCCore.ClientRequest<Lumbay2sv_Empty>,
            serializer: some GRPCCore.MessageSerializer<Lumbay2sv_Empty>,
            deserializer: some GRPCCore.MessageDeserializer<Lumbay2sv_Update>,
            options: GRPCCore.CallOptions = .defaults,
            onResponse handleResponse: @Sendable @escaping (GRPCCore.StreamingClientResponse<Lumbay2sv_Update>) async throws -> Result
        ) async throws -> Result where Result: Sendable {
            try await self.client.serverStreaming(
                request: request,
                descriptor: Lumbay2sv_LumbayLumbay.Method.Subscribe.descriptor,
                serializer: serializer,
                deserializer: deserializer,
                options: options,
                onResponse: handleResponse
            )
        }
    }
}

// Helpers providing default arguments to 'ClientProtocol' methods.
extension Lumbay2sv_LumbayLumbay.ClientProtocol {
    /// Call the "SendRequest" method.
    ///
    /// - Parameters:
    ///   - request: A request containing a single `Lumbay2sv_Request` message.
    ///   - options: Options to apply to this RPC.
    ///   - handleResponse: A closure which handles the response, the result of which is
    ///       returned to the caller. Returning from the closure will cancel the RPC if it
    ///       hasn't already finished.
    /// - Returns: The result of `handleResponse`.
    internal func sendRequest<Result>(
        request: GRPCCore.ClientRequest<Lumbay2sv_Request>,
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Lumbay2sv_Reply>) async throws -> Result = { response in
            try response.message
        }
    ) async throws -> Result where Result: Sendable {
        try await self.sendRequest(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Lumbay2sv_Request>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Lumbay2sv_Reply>(),
            options: options,
            onResponse: handleResponse
        )
    }

    /// Call the "Subscribe" method.
    ///
    /// - Parameters:
    ///   - request: A request containing a single `Lumbay2sv_Empty` message.
    ///   - options: Options to apply to this RPC.
    ///   - handleResponse: A closure which handles the response, the result of which is
    ///       returned to the caller. Returning from the closure will cancel the RPC if it
    ///       hasn't already finished.
    /// - Returns: The result of `handleResponse`.
    internal func subscribe<Result>(
        request: GRPCCore.ClientRequest<Lumbay2sv_Empty>,
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.StreamingClientResponse<Lumbay2sv_Update>) async throws -> Result
    ) async throws -> Result where Result: Sendable {
        try await self.subscribe(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Lumbay2sv_Empty>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Lumbay2sv_Update>(),
            options: options,
            onResponse: handleResponse
        )
    }
}

// Helpers providing sugared APIs for 'ClientProtocol' methods.
extension Lumbay2sv_LumbayLumbay.ClientProtocol {
    /// Call the "SendRequest" method.
    ///
    /// - Parameters:
    ///   - message: request message to send.
    ///   - metadata: Additional metadata to send, defaults to empty.
    ///   - options: Options to apply to this RPC, defaults to `.defaults`.
    ///   - handleResponse: A closure which handles the response, the result of which is
    ///       returned to the caller. Returning from the closure will cancel the RPC if it
    ///       hasn't already finished.
    /// - Returns: The result of `handleResponse`.
    internal func sendRequest<Result>(
        _ message: Lumbay2sv_Request,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Lumbay2sv_Reply>) async throws -> Result = { response in
            try response.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Lumbay2sv_Request>(
            message: message,
            metadata: metadata
        )
        return try await self.sendRequest(
            request: request,
            options: options,
            onResponse: handleResponse
        )
    }

    /// Call the "Subscribe" method.
    ///
    /// - Parameters:
    ///   - message: request message to send.
    ///   - metadata: Additional metadata to send, defaults to empty.
    ///   - options: Options to apply to this RPC, defaults to `.defaults`.
    ///   - handleResponse: A closure which handles the response, the result of which is
    ///       returned to the caller. Returning from the closure will cancel the RPC if it
    ///       hasn't already finished.
    /// - Returns: The result of `handleResponse`.
    internal func subscribe<Result>(
        _ message: Lumbay2sv_Empty,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.StreamingClientResponse<Lumbay2sv_Update>) async throws -> Result
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Lumbay2sv_Empty>(
            message: message,
            metadata: metadata
        )
        return try await self.subscribe(
            request: request,
            options: options,
            onResponse: handleResponse
        )
    }
}