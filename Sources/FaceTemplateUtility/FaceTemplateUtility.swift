import Foundation

/// Utility for comparing and converting Ver-ID face templates
public struct FaceTemplateUtility {
    
    private static let standardDeviation: Float = 0.1786
    
    // MARK: - Face template comparison
    
    /// Compare two face templates using unit norms
    /// - Parameters:
    ///   - template1: First face template
    ///   - template2: Second face template
    /// - Since: 1.0.0
    public static func compareFaceTemplate(_ template1: String, to template2: String) throws -> Float {
        return compareFaceTemplate(try faceTemplateFromString(template1), to: try faceTemplateFromString(template2))
    }
    
    /// Compare two face templates using unit norms
    /// - Parameters:
    ///   - template1: First face template
    ///   - template2: Second face template
    /// - Since: 1.0.0
    public static func compareFaceTemplate(_ template1: [Float], to template2: [Float]) -> Float {
        return innerProduct(template1, template2) / standardDeviation
    }
    
    /// Compare two face templates using given norms
    /// - Parameters:
    ///   - template1: First face template
    ///   - norm1: First face template norm
    ///   - template2: Second face template
    ///   - norm2: Second face template norm
    /// - Since: 1.0.0
    public static func compareFaceTemplate(_ template1: [Float], withNorm norm1: Float, to template2: [Float], withNorm norm2: Float) -> Float {
        return innerProduct(template1, template2) / (norm1 * norm2) / standardDeviation
    }
    
    /// Get norm for face template
    /// - Parameter template: Face template
    /// - Since: 1.0.0
    public static func normForTemplate(_ template: [Float]) -> Float {
        return sqrtf(innerProduct(template, template))
    }
    
    private static func innerProduct(_ template1: [Float], _ template2: [Float]) -> Float {
        var sum: Float = 0
        for i in 0..<min(template1.count, template2.count) {
            sum += template1[i] * template2[i]
        }
        return sum
    }
    
    // MARK: - Face template conversion
    
    /// Convert face template to string
    /// - Parameter template: Face template to be converted
    /// - Since: 1.0.0
    public static func stringFromFaceTemplate(_ template: [Float]) -> String {
        let floats: [CFSwappedFloat32] = template.map({ CFConvertFloat32HostToSwapped($0) })
        var bytes: [UInt8] = []
        for var float in floats {
            let floatBytes = withUnsafeBytes(of: &float) { Array($0) }
            bytes.append(contentsOf: floatBytes)
        }
        let data = Data(bytes)
        return data.base64EncodedString()
    }
    
    /// Convert string to face template
    /// - Parameter string: String representing base 64 encoded face template
    /// - Since: 1.0.0
    public static func faceTemplateFromString(_ string: String) throws -> [Float] {
        guard let data = Data(base64Encoded: string) else {
            throw FaceTemplateConversionError.base64ConversionFailed
        }
        let bytes = [UInt8](data)
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
