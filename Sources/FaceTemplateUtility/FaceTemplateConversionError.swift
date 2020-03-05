//
//  File.swift
//  
//
//  Created by Jakub Dolejs on 05/03/2020.
//

/// Errors thrown when converting strings to face templates
/// - Since: 1.0.0
public enum FaceTemplateConversionError: Error {
    /// Conversion from base 64 encoded string failed
    /// - Since: 1.0.0
    case base64ConversionFailed
}
