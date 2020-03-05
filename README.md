![Swift](https://github.com/AppliedRecognition/Face-Template-Utlity-Apple/workflows/Swift/badge.svg?event=push)

# Face Template Utility

### Utility for converting and comparing raw [Ver-ID](https://github.com/AppliedRecognition/Ver-ID-UI-iOS) face templates

## Obtaining a raw face template

1. [Follow the instructions](https://github.com/AppliedRecognition/Ver-ID-UI-iOS) to install Ver-ID SDK for iOS.
2. Example function to detect a face and get its raw template:
    
    ~~~swift
    import VerIDCore
    
    func rawFaceTemplateFromImage(url: URL) -> [Float]? {
        let verid = VerIDFactory().createVerIDSync()
        guard let image = VerIDImage(url: url) else {
            // Failed to create image from URL
            return nil
        }
        guard let faces = try? verid.faceDetection.detectFacesInImage(image, limit: 1), !faces.isEmpty else {
            // No face found in image
            return nil
        }
        guard let faceRecognition = verid.faceRecognition as? VerIDFaceRecognition else {
            // Using face recognition implementation that does not support extracting raw face templates
            return nil
        }
        guard let recognizableFace = (try? faceRecognition.createRecognizableFacesFromFaces(faces, inImage: image))?.first else {
            // Failed to create recognizable face
            return nil
        }
        guard let template = try? faceRecognition.rawFaceTemplate(fromFace: recognizableFace) else {
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
    let threshold: Float = 4.0
    let score: Float = FaceTemplateUtility.compareFaceTemplate(template1, to: template2)
    return score > threshold
}
~~~

## [Reference documentation](https://appliedrecognition.github.io/Face-Template-Utility-Apple)
