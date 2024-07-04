//
//  PassKitError.swift
//  PassKit
//
//  Created by Francesco Paolo Severino on 04/07/24.
//

/// Errors that can be thrown by PassKit.
public struct PassKitError: Error, Sendable {
    /// The type of the errors that can be thrown by PassKit.
    public struct ErrorType: Sendable, Hashable, CustomStringConvertible {
        enum Base: String, Sendable {
            case templateNotDirectory
            case pemCertificateMissing
            case pemPrivateKeyMissing
            case zipBinaryMissing
            case opensslBinaryMissing
        }
        
        let base: Base
        
        private init(_ base: Base) {
            self.base = base
        }
        
        /// The template path is not a directory.
        public static let templateNotDirectory = Self(.templateNotDirectory)
        /// The `pemCertificate` file is missing.
        public static let pemCertificateMissing = Self(.pemCertificateMissing)
        /// The `pemPrivateKey` file is missing.
        public static let pemPrivateKeyMissing = Self(.pemPrivateKeyMissing)
        /// The path to the `zip` binary is incorrect.
        public static let zipBinaryMissing = Self(.zipBinaryMissing)
        /// The path to the `openssl` binary is incorrect.
        public static let opensslBinaryMissing = Self(.opensslBinaryMissing)

        /// A textual representation of this error.
        public var description: String {
            base.rawValue
        }
    }
    
    private struct Backing: Sendable {
        fileprivate let errorType: ErrorType
        fileprivate let framework: Framework
        
        init(errorType: ErrorType, framework: Framework) {
            self.errorType = errorType
            self.framework = framework
        }
    }
    
    private var backing: Backing

    /// The type of this error.
    public var errorType: ErrorType { backing.errorType }

    /// The framework that threw this error.
    public var framework: Framework { backing.framework }

    private init(errorType: ErrorType, framework: Framework) {
        self.backing = .init(errorType: errorType, framework: framework)
    }
    
    /// The template path is not a directory.
    public static func templateNotDirectory(_ framework: Framework) -> Self {
        Self(errorType: .templateNotDirectory, framework: framework)
    }

    /// The `pemCertificate` file is missing.
    public static func pemCertificateMissing(_ framework: Framework) -> Self {
        Self(errorType: .pemCertificateMissing, framework: framework)
    }

    /// The `pemPrivateKey` file is missing.
    public static func pemPrivateKeyMissing(_ framework: Framework) -> Self {
        Self(errorType: .pemPrivateKeyMissing, framework: framework)
    }

    /// The path to the `zip` binary is incorrect.
    public static func zipBinaryMissing(_ framework: Framework) -> Self {
        Self(errorType: .zipBinaryMissing, framework: framework)
    }

    /// The path to the `openssl` binary is incorrect.
    public static func opensslBinaryMissing(_ framework: Framework) -> Self {
        Self(errorType: .opensslBinaryMissing, framework: framework)
    }
}

extension PassKitError: CustomStringConvertible {
    public var description: String {
        "PassKitError(errorType: \(self.errorType), framework: \(self.framework))"
    }
}

/// The frameworks offered by PassKit.
public enum Framework: String, Sendable {
    /// Apple Wallet passes.
    case passes
    /// Apple Wallet orders.
    case orders
}
