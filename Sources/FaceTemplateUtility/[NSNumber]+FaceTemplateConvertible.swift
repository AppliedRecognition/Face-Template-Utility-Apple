//
//  File.swift
//  
//
//  Created by Jakub Dolejs on 09/03/2020.
//

import Foundation

extension Array: FaceTemplateConvertible where Element == NSNumber {
    
    public init(from faceTemplate: [Float]) throws {
        self = faceTemplate.map({NSNumber(value: $0)})
    }
    
    public func faceTemplate() throws -> [Float] {
        return self.map({$0.floatValue})
    }
}
