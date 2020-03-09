//
//  FaceTemplateConvertible.swift
//  
//
//  Created by Jakub Dolejs on 09/03/2020.
//

import Foundation

/// Makes a type convertible to a face template
/// - Since: 2.1.0
public protocol FaceTemplateConvertible {
    
    /// Initialize from a face template
    /// - Parameter faceTemplate: Face template
    /// - Since: 2.1.0
    init(from faceTemplate: [Float]) throws    
    
    /// Convert to a face template
    /// - Since: 2.1.0
    func faceTemplate() throws -> [Float]
}
