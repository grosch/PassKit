//
//  OrdersDevice.swift
//  PassKit
//
//  Created by Francesco Paolo Severino on 30/06/24.
//

import FluentKit
import PassKit

/// The `Model` that stores Wallet orders devices.
final public class OrdersDevice: DeviceModel, @unchecked Sendable {
    public static let schema = OrdersDevice.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    @Field(key: OrdersDevice.FieldKeys.pushToken)
    public var pushToken: String

    @Field(key: OrdersDevice.FieldKeys.deviceLibraryIdentifier)
    public var deviceLibraryIdentifier: String

    public init(deviceLibraryIdentifier: String, pushToken: String) {
        self.deviceLibraryIdentifier = deviceLibraryIdentifier
        self.pushToken = pushToken
    }

    public init() {}
}

extension OrdersDevice: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(Self.schema)
            .field(.id, .int, .identifier(auto: true))
            .field(OrdersDevice.FieldKeys.pushToken, .string, .required)
            .field(OrdersDevice.FieldKeys.deviceLibraryIdentifier, .string, .required)
            .unique(on: OrdersDevice.FieldKeys.pushToken, OrdersDevice.FieldKeys.deviceLibraryIdentifier)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(Self.schema).delete()
    }
}

extension OrdersDevice {
    enum FieldKeys {
        static let schemaName = "orders_devices"
        static let pushToken = FieldKey(stringLiteral: "push_token")
        static let deviceLibraryIdentifier = FieldKey(stringLiteral: "device_library_identifier")
    }
}