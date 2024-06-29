//
//  PassesErrorLog.swift
//  PassKit
//
//  Created by Francesco Paolo Severino on 29/06/24.
//

import Foundation
import FluentKit
import PassKit

/// The `Model` that stores PassKit passes error logs.
final public class PassesErrorLog: ErrorLogModel, @unchecked Sendable {
    public static let schema = PassesErrorLog.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    @Timestamp(key: PassesErrorLog.FieldKeys.createdAt, on: .create)
    public var createdAt: Date?

    @Field(key: PassesErrorLog.FieldKeys.message)
    public var message: String

    public init(message: String) {
        self.message = message
    }

    public init() {}
}

extension PassesErrorLog: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(Self.schema)
            .field(.id, .int, .identifier(auto: true))
            .field(PassesErrorLog.FieldKeys.createdAt, .datetime, .required)
            .field(PassesErrorLog.FieldKeys.message, .string, .required)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(Self.schema).delete()
    }
}

extension PassesErrorLog {
    enum FieldKeys {
        static let schemaName = "passes_errors"
        static let createdAt = FieldKey(stringLiteral: "created_at")
        static let message = FieldKey(stringLiteral: "message")
    }
}