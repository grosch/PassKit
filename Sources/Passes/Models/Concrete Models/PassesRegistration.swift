//
//  PassesRegistration.swift
//  PassKit
//
//  Created by Francesco Paolo Severino on 29/06/24.
//

import Foundation
import FluentKit

/// The `Model` that stores passes registrations.
final public class PassesRegistration: PassesRegistrationModel, @unchecked Sendable {
    public typealias PassType = PKPass
    public typealias DeviceType = PassesDevice

    public static let schema = PassesRegistration.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    @Parent(key: PassesRegistration.FieldKeys.deviceID)
    public var device: DeviceType

    @Parent(key: PassesRegistration.FieldKeys.passID)
    public var pass: PassType

    public init() {}
}

extension PassesRegistration: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(Self.schema)
            .field(.id, .int, .identifier(auto: true))
            .field(PassesRegistration.FieldKeys.deviceID, .int, .required, .references(DeviceType.schema, .id, onDelete: .cascade))
            .field(PassesRegistration.FieldKeys.passID, .uuid, .required, .references(PassType.schema, .id, onDelete: .cascade))
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(Self.schema).delete()
    }
}

extension PassesRegistration {
    enum FieldKeys {
        static let schemaName = "passes_registrations"
        static let deviceID = FieldKey(stringLiteral: "device_id")
        static let passID = FieldKey(stringLiteral: "pass_id")
    }
}
