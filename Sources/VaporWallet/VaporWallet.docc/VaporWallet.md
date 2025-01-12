# ``VaporWallet``

Create, distribute, and update passes and orders for the Apple Wallet app with Vapor.

## Overview

The `VaporWallet` framework provides a set of tools shared by the `VaporWalletPasses` and `VaporWalletOrders` frameworks.

@Row {
    @Column(size: 2) { }
    @Column {
        ![Apple Wallet](wallet)
    }
    @Column(size: 2) { }
}

### 🎟️ Wallet Passes

The `VaporWalletPasses` framework provides a set of tools to help you create, build, and distribute digital passes for the Apple Wallet app using a Vapor server.
It also provides a way to update passes after they have been distributed, using APNs, and models to store pass and device data.

See the framework's [documentation](https://swiftpackageindex.com/vapor-community/PassKit/documentation/passes) for information and guides on how to use it.

For information on Apple Wallet passes, see the [Apple Developer Documentation](https://developer.apple.com/documentation/walletpasses).

### 📦 Wallet Orders

The `VaporWalletOrders` framework provides a set of tools to help you create, build, and distribute orders that users can track and manage in Apple Wallet using a Vapor server.
It also provides a way to update orders after they have been distributed, using APNs, and models to store order and device data.

See the framework's [documentation](https://swiftpackageindex.com/vapor-community/PassKit/documentation/orders) for information and guides on how to use it.

For information on Apple Wallet orders, see the [Apple Developer Documentation](https://developer.apple.com/documentation/walletorders).
