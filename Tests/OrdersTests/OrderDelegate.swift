import Vapor
import Fluent
import Orders

final class OrderDelegate: OrdersDelegate {
    let sslSigningFilesDirectory = URL(fileURLWithPath: "Certificates/Orders/", isDirectory: true)

    let pemPrivateKeyPassword: String? = "password"
    
    func encode<O: OrderModel>(order: O, db: any Database, encoder: JSONEncoder) async throws -> Data {
        guard let orderData = try await OrderData.query(on: db)
            .filter(\.$order.$id == order.requireID())
            .with(\.$order)
            .first()
        else {
            throw Abort(.internalServerError)
        }
        guard let data = try? encoder.encode(OrderJSONData(data: orderData, order: orderData.order)) else {
            throw Abort(.internalServerError)
        }
        return data
    }

    func template<O: OrderModel>(for: O, db: any Database) async throws -> URL {
        return URL(fileURLWithPath: "Templates/Orders/", isDirectory: true)
    }
}
