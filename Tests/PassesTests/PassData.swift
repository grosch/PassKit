import Fluent
import struct Foundation.UUID
import Passes
import Vapor

final class PassData: PassDataModel, @unchecked Sendable {
    static let schema = PassData.vddMMyyyy.schemaName
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: PassData.vddMMyyyy.title)
    var title: String
    
    @Parent(key: PassData.vddMMyyyy.passID)
    var pass: PKPass

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
    
    func toDTO() -> PassDataDTO {
        .init(
            id: self.id,
            title: self.$title.value
        )
    }
}

struct PassDataDTO: Content {
    var id: UUID?
    var title: String?
    
    func toModel() -> PassData {
        let model = PassData()
        
        model.id = self.id
        if let title = self.title {
            model.title = title
        }
        return model
    }
}

struct CreatePassData: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(PassData.vddMMyyyy.schemaName)
            .id()
            .field(PassData.vddMMyyyy.title, .string, .required)
            .field(PassData.vddMMyyyy.passID, .uuid, .required, .references(PKPass.schema, .id, onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(PassData.vddMMyyyy.schemaName).delete()
    }
}

extension PassData {
    enum vddMMyyyy {
        static let schemaName = "pass_data"
        static let title = FieldKey(stringLiteral: "title")
        static let passID = FieldKey(stringLiteral: "pass_id")
    }
}

struct PassJSONData: PassJSON.Properties {
    let description: String
    let formatVersion = PassJSON.FormatVersion.v1
    let organizationName = "vapor-community"
    let passTypeIdentifier = "pass.com.vapor-community.pass"
    let serialNumber: String
    let teamIdentifier = "ABCD1234"

    private let webServiceURL = "https://www.example.com/api/passes/"
    private let authenticationToken: String
    private let logoText = "Vapor"
    private let sharingProhibited = true
    let backgroundColor = "rgb(207, 77, 243)"
    let foregroundColor = "rgb(255, 255, 255)"
    
    let barcodes = Barcode(message: "test")
    struct Barcode: PassJSON.Barcodes {
        let format = PassJSON.BarcodeFormat.qr
        let message: String
        let messageEncoding = "iso-8859-1"
    }
    
    let boardingPass = Boarding(transitType: .air)
    struct Boarding: PassJSON.BoardingPass {
        let transitType: PassJSON.TransitType
        let headerFields: [PassField]
        let primaryFields: [PassField]
        let secondaryFields: [PassField]
        let auxiliaryFields: [PassField]
        let backFields: [PassField]

        struct PassField: PassJSON.PassFieldContent {
            let key: String
            let label: String
            let value: String
        }

        init(transitType: PassJSON.TransitType) {
            self.headerFields = [.init(key: "header", label: "Header", value: "Header")]
            self.primaryFields = [.init(key: "primary", label: "Primary", value: "Primary")]
            self.secondaryFields = [.init(key: "secondary", label: "Secondary", value: "Secondary")]
            self.auxiliaryFields = [.init(key: "auxiliary", label: "Auxiliary", value: "Auxiliary")]
            self.backFields = [.init(key: "back", label: "Back", value: "Back")]
            self.transitType = transitType
        }
    }

    init(data: PassData, pass: PKPass) {
        self.description = data.title
        self.serialNumber = pass.id!.uuidString
        self.authenticationToken = pass.authenticationToken
    }
}

struct PersonalizationJSONData: PersonalizationJSON.Properties {
    var requiredPersonalizationFields = [
        PersonalizationJSON.PersonalizationField.name,
        PersonalizationJSON.PersonalizationField.postalCode,
        PersonalizationJSON.PersonalizationField.emailAddress,
        PersonalizationJSON.PersonalizationField.phoneNumber
    ]
    var description = "Hello, World!"
}

struct PassDataMiddleware: AsyncModelMiddleware {
    private unowned let service: PassesService

    init(service: PassesService) {
        self.service = service
    }

    func create(model: PassData, on db: any Database, next: any AnyAsyncModelResponder) async throws {
        let pkPass = PKPass(
            passTypeIdentifier: "pass.com.vapor-community.pass",
            authenticationToken: Data([UInt8].random(count: 12)).base64EncodedString())
        try await pkPass.save(on: db)
        model.$pass.id = try pkPass.requireID()
        try await next.create(model, on: db)
    }

    func update(model: PassData, on db: any Database, next: any AnyAsyncModelResponder) async throws {
        let pkPass = try await model.$pass.get(on: db)
        pkPass.updatedAt = Date()
        try await pkPass.save(on: db)
        try await next.update(model, on: db)
        try await service.sendPushNotifications(for: pkPass, on: db)
    }
}
