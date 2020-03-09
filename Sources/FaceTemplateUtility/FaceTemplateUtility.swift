import Foundation

/// Utility for comparing and converting Ver-ID face templates
/// - Since: 1.0.0
public class FaceTemplateUtility {
    
    /// Default standard deviation value to use at comparison
    /// - Since: 1.1.0
    public static let defaultStandardDeviation: Float = 0.1786
    
    /// Standard deviation used when comparing face templates
    /// - Since: 1.1.0
    private(set) public var standardDeviation: Float = FaceTemplateUtility.defaultStandardDeviation
    private var norm: Float?
    
    private init(standardDeviation: Float? = nil, norm: Float? = nil) {
        self.standardDeviation = standardDeviation ?? FaceTemplateUtility.defaultStandardDeviation
        self.norm = norm
    }
    
    // MARK: - Setup
    
    /// Initialize an instance with default settings
    /// - Since: 1.1.0
    public static var `default`: FaceTemplateUtility {
        return FaceTemplateUtility()
    }
    
    /// Initialize an instance with unit norm (1)
    /// - Since: 1.1.0
    public static var withUnitNorm: FaceTemplateUtility {
        return FaceTemplateUtility(standardDeviation: nil, norm: 1)
    }
    
    /// Initialize an instance with given standard deviation to use when comparing face templates
    /// - Parameter standardDeviation: Standard deviation
    /// - Since: 1.1.0
    public static func withStandardDeviation(_ standardDeviation: Float) -> FaceTemplateUtility {
        return FaceTemplateUtility(standardDeviation: standardDeviation)
    }
    
    /// Set standard deviation on an instance and return the instance
    /// - Parameter standardDeviation: Standard deviation
    /// - Since: 1.1.0
    public func setStandardDeviation(_ standardDeviation: Float) -> FaceTemplateUtility {
        self.standardDeviation = standardDeviation
        return self
    }
    
    // MARK: - Face template comparison
    
    /// Compare two face templates
    /// - Parameters:
    ///   - template1: First face template
    ///   - template2: Second face template
    /// - Since: 1.0.0
    public static func compareFaceTemplate(_ template1: String, to template2: String) throws -> Float {
        return try FaceTemplateUtility.default.compareFaceTemplate(template1, to: template2)
    }
    
    /// Compare two face templates
    /// - Parameters:
    ///   - template1: First face template
    ///   - template2: Second face template
    /// - Since: 1.0.0
    public static func compareFaceTemplate(_ template1: [Float], to template2: [Float]) -> Float {
        return FaceTemplateUtility.default.compareFaceTemplate(template1, to: template2)
    }
    
    /// Compare two face templates using given norms
    /// - Parameters:
    ///   - template1: First face template
    ///   - norm1: First face template norm
    ///   - template2: Second face template
    ///   - norm2: Second face template norm
    /// - Since: 1.0.0
    public static func compareFaceTemplate(_ template1: [Float], withNorm norm1: Float, to template2: [Float], withNorm norm2: Float) -> Float {
        let utility = FaceTemplateUtility.default
        return utility.innerProduct(template1, template2) / (norm1 * norm2) / utility.standardDeviation
    }
    
    /// Get norm for face template
    /// - Parameter template: Face template
    /// - Since: 1.0.0
    public static func normForTemplate(_ template: [Float]) -> Float {
        return FaceTemplateUtility.default.normForFaceTemplate(template)
    }
    
    /// Compare two face templates
    /// - Note: The return value will depend on the value of the `standardDeviation` property.
    /// - Parameters:
    ///   - template1: First face template
    ///   - template2: Second face template
    /// - Returns: Score that indicates similarity between the two templates
    /// - Since: 1.1.0
    public func compareFaceTemplate(_ template1: FaceTemplateConvertible, to template2: FaceTemplateConvertible) throws -> Float {
        let t1 = try template1.faceTemplate()
        let t2 = try template2.faceTemplate()
        return self.compareFaceTemplate(t1, to: t2)
    }
    
    /// Compare two face templates
    /// - Note: The return value will depend on the value of the `standardDeviation` property.
    /// - Parameters:
    ///   - template1: First face template
    ///   - template2: Second face template
    /// - Returns: Score that indicates similarity between the two templates
    /// - Since: 1.1.0
    public func compareFaceTemplate(_ template1: [Float], to template2: [Float]) -> Float {
        let norm1 = self.norm ?? self.normForFaceTemplate(template1)
        let norm2 = self.norm ?? self.normForFaceTemplate(template2)
        return self.innerProduct(template1, template2) / (norm1 * norm2) / self.standardDeviation
    }
    
    /// Get a norm for the specified face template
    /// - Parameter template: Face template
    /// - Since: 1.1.0
    public func normForFaceTemplate(_ template: FaceTemplateConvertible) throws -> Float {
        let t = try template.faceTemplate()
        return sqrtf(innerProduct(t, t))
    }
    
    /// Get a norm for the specified face template
    /// - Parameter template: Face template
    /// - Since: 1.1.0
    public func normForFaceTemplate(_ faceTemplate: [Float]) -> Float {
        return sqrtf(self.innerProduct(faceTemplate, faceTemplate))
    }
    
    private func innerProduct(_ template1: [Float], _ template2: [Float]) -> Float {
        var sum: Float = 0
        for i in 0..<min(template1.count, template2.count) {
            sum += template1[i] * template2[i]
        }
        return sum
    }
    
    // MARK: - Face template conversion
    
    /// Convert face template to string
    /// - Note: As of version 1.1.0 the framework contains a `String` extension that conforms to `FaceTemplateEncodable`, making this function redundant.
    /// - Parameter template: Face template to be converted
    /// - Since: 1.0.0
    public static func stringFromFaceTemplate(_ template: [Float]) -> String {
        return try! String(from: template)
    }
    
    /// Convert string to face template
    /// - Note: As of version 1.1.0 the framework contains a `String` extension that conforms to `FaceTemplateDecodable`, making this function redundant.
    /// - Parameter string: String representing base 64 encoded face template
    /// - Since: 1.0.0
    public static func faceTemplateFromString(_ string: String) throws -> [Float] {
        return try string.faceTemplate()
    }
}
