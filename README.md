# Face Template Utility

### Utility for converting and comparing raw [Ver-ID](https://github.com/AppliedRecognition/Ver-ID-UI-iOS) face templates

## Obtaining a raw face template

1. [Follow the instructions](https://github.com/AppliedRecognition/Ver-ID-UI-iOS) to install Ver-ID SDK for iOS.
2. Example function to detect a face and get its raw template:
    
    ~~~swift
    import VerIDCore
    
    func rawFaceTemplateFromImage(url: URL) -> [Float]? {
        let verid = VerIDFactory().createVerIDSync()
        guard let face = (try? verid.faceDetection.detectRecognizableFacesInImage(url, limit: 1))?.first else {
            // No face found in image
            return nil
        }
        guard let faceRecognition = verid.faceRecognition as? VerIDFaceRecognition else {
            // Not using Ver-ID face recognition
            return nil
        }
        guard let template = try? faceRecognition.rawFaceTemplate(fromFace: face) else {
            // Failed to get raw template
            return nil
        }
        // Convert from [NSNumber] to [Float]
        return template.map({ $0.floatValue })
    }
    ~~~

## Converting face templates to strings

If you're going to be storing raw face templates you may want to convert them to strings.

1. Convert face template to string:

    ~~~swift
    import FaceTemplateUtility
    
    let string: String = FaceTemplateUtility.stringFromFaceTemplate(template)
    ~~~
2. Convert string to face template:

    ~~~swift
    import FaceTemplateUtility
    
    do {
        let faceTemplate: [Float] = try FaceTemplateUtility.faceTemplateFromString(string)
    } catch {
        // Conversion failed
    }
    ~~~
    
## Comparing face templates

~~~swift
import FaceTemplateUtility

func isFaceTemplate(_ template1: [Float], similarTo template2: [Float]) -> Bool {
    let score: Float = FaceTemplateUtility.compareFaceTemplate(template1, to: template2)
    return score > 0.5
}
~~~

## [Reference documentation](https://appliedrecognition.github.io/Face-Template-Utility-Apple)