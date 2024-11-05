import FluentKit
import FluentSQLiteDriver
import Orders
import PassKit
import Testing
import Vapor
import Zip

func withApp(
    useEncryptedKey: Bool = false,
    _ body: (Application, OrdersService) async throws -> Void
) async throws {
    let app = try await Application.make(.testing)
    do {
        try #require(isLoggingConfigured)

        app.databases.use(.sqlite(.memory), as: .sqlite)
        OrdersService.register(migrations: app.migrations)
        app.migrations.add(CreateOrderData())
        try await app.autoMigrate()

        let delegate = TestOrdersDelegate()
        let ordersService = try OrdersService(
            app: app,
            delegate: delegate,
            pushRoutesMiddleware: SecretMiddleware(secret: "foo"),
            logger: app.logger,
            pemWWDRCertificate: TestCertificate.pemWWDRCertificate,
            pemCertificate: useEncryptedKey ? TestCertificate.encryptedPemCertificate : TestCertificate.pemCertificate,
            pemPrivateKey: useEncryptedKey ? TestCertificate.encryptedPemPrivateKey : TestCertificate.pemPrivateKey,
            pemPrivateKeyPassword: useEncryptedKey ? "password" : nil
        )
        app.databases.middleware.use(OrderDataMiddleware(service: ordersService), on: .sqlite)

        Zip.addCustomFileExtension("order")

        try await body(app, ordersService)

        try await app.autoRevert()
    } catch {
        try await app.asyncShutdown()
        throw error
    }
    try await app.asyncShutdown()
}
