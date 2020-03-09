//
//  FaceTemplateConvertible.swift
//  
//
//  Created by Jakub Dolejs on 09/03/2020.
//

import Foundation

/// Makes `Data` convertible to a face template
/// - Since: 1.1.0
extension Data: FaceTemplateConvertible {
    
    /// Initialize `Data` from a face template
    /// - Parameter faceTemplate: Face template
    /// - Since: 1.1.0
    public init(from faceTemplate: [Float]) throws {
        let floats: [CFSwappedFloat32] = faceTemplate.map({ CFConvertFloat32HostToSwapped($0) })
        var bytes: [UInt8] = []
        for var float in floats {
            let floatBytes = Swift.withUnsafeBytes(of: &float) { Array($0) }
            bytes.append(contentsOf: floatBytes)
        }
        self.init(bytes)
    }
    
    /// Convert this `Data` to a face template
    /// - Since: 1.1.0
    public func faceTemplate() throws -> [Float] {
        let bytes = [UInt8](self)
        var floats: [Float] = []
        for i in stride(from: 0, to:bytes.count, by: 4) {
            let byteRange: [UInt8] = [UInt8](bytes[i..<i+4])
            let uint32 = UnsafePointer(byteRange).withMemoryRebound(to: UInt32.self, capacity: 1) {
                $0.pointee
            }
            let swappedFloat: CFSwappedFloat32 = CFSwappedFloat32(v: uint32);
            let f32: Float = CFConvertFloat32SwappedToHost(swappedFloat)
            floats.append(f32)
        }
        return floats
    }
}
