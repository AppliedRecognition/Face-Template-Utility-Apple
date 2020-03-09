//
//  File.swift
//  
//
//  Created by Jakub Dolejs on 09/03/2020.
//

import Foundation

/// Makes `[NSNumber]` convertible to a face template
/// - Note: `[NSNumber]` is the raw face template type returned by the Ver-ID SDK
/// - Since: 2.1.0
extension Array: FaceTemplateConvertible where Element == NSNumber {
    
    /// Initialize `[NSNumber]` from a face template
    /// - Parameter faceTemplate: Face template
    /// - Since: 2.1.0
    public init(from faceTemplate: [Float]) throws {
        self = faceTemplate.map({NSNumber(value: $0)})
    }
    
    /// Convert this `[NSNumber]` to a face template
    /// - Since: 2.1.0
    public func faceTemplate() throws -> [Float] {
        return self.map({$0.floatValue})
    }
}
