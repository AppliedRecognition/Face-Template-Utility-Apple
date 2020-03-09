//
//  File.swift
//  
//
//  Created by Jakub Dolejs on 09/03/2020.
//

import Foundation

/// Makes `String` convertible to a face template
/// - Since: 1.1.0 
extension String: FaceTemplateConvertible {
    
    /// Initialize a string from a face template
    /// - Parameter faceTemplate: Face template
    /// - Since: 1.1.0
    public init(from faceTemplate: [Float]) throws {
        let data = try Data(from: faceTemplate)
        self = data.base64EncodedString()
    }
    
    /// Convert this string to a face template
    /// - Since: 1.1.0
    public func faceTemplate() throws -> [Float] {
        guard let data = Data(base64Encoded: self) else {
            throw FaceTemplateConversionError.base64ConversionFailed
        }
        return try data.faceTemplate()
    }
}
