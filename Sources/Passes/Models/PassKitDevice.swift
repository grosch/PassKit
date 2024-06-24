/// Copyright 2020 Gargoyle Software, LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Vapor
import Fluent

/// Represents the `Model` that stores PassKit devices.
public protocol PassKitDevice: Model where IDValue == Int {
    /// The push token used for sending updates to the device.
    var pushToken: String { get set }
    
    /// The identifier PassKit provides for the device.
    var deviceLibraryIdentifier: String { get set }
    
    /// The designated initializer.
    /// - Parameters:
    ///   - deviceLibraryIdentifier: The device identifier as provided during registration.
    ///   - pushToken: The push token to use when sending updates via push notifications.
    init(deviceLibraryIdentifier: String, pushToken: String)
}

internal extension PassKitDevice {
    var _$id: ID<Int> {
        guard let mirror = Mirror(reflecting: self).descendant("_id"),
            let id = mirror as? ID<Int> else {
                fatalError("id property must be declared using @ID")
        }
        
        return id
    }
    
    var _$pushToken: Field<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_pushToken"),
            let pushToken = mirror as? Field<String> else {
                fatalError("pushToken property must be declared using @Field")
        }
        
        return pushToken
    }
    
    var _$deviceLibraryIdentifier: Field<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_deviceLibraryIdentifier"),
            let deviceLibraryIdentifier = mirror as? Field<String> else {
                fatalError("deviceLibraryIdentifier property must be declared using @Field")
        }
        
        return deviceLibraryIdentifier
    }
}

