//
//  backgroundRemoval.swift
//  backgroundRemoval
//
//  Created by Ezaldeen on 17/03/2022.
//

import UIKit
import CoreML
import Vision

enum ImageProcessingError: Error {
    case processingError
    case inversionError
    case scalingError
    case sizingError
    case maskingError
}

public struct BackgroundRemoval {
    public init() {
    }
    
    ///@param uploadedImage of the input image
    ///@param filterSharpness tha sharpness of filter if needed (recommeneded)
    ///@param maskOnly pass true if you want the mask onl, not the output image
    
    public func removeBackground(image: UIImage, maskOnly: Bool = false) throws -> UIImage {
        let w = image.size.width
        let h = image.size.height
        
        /// determine whether width or height is greater
        let longer = max(w, h)
        /// create a Square size box
        let sz = CGSize(width: longer, height: longer)
        
        /// call scaling function to scale the image to the Square dimensions, using "aspect fit"
        guard let scaledImage = image.scaled(to: sz, scalingMode: .aspectFit) else {
            throw ImageProcessingError.scalingError
        }
        
        /// resize image to 320 * 320 before sending it to the model
        guard let resize =  scaledImage.resizeImage(width: 320, height: 320) else {
            throw ImageProcessingError.sizingError
        }
        
        /// init model and get result
        guard let model = try? LaLabsu2netp.init(),
              let bufferResized = buffer(from: resize),
              let result = try? model.prediction(in_0: bufferResized),
              let out = UIImage(pixelBuffer: result.out_p1) else {
            throw ImageProcessingError.processingError
        }
        
        guard let scaledOut = out.scaled(to: sz, scalingMode: .aspectFit),
              let invertedOut = scaledOut.invertedImage() else {
            throw ImageProcessingError.inversionError
        }
        
        guard let finalResult = scaledImage.maskImage(withMask: invertedOut) else {
            throw ImageProcessingError.maskingError
        }
        
        return maskOnly ? scaledOut : finalResult
    }
    
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        guard let pixelBufferUnwrapped = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBufferUnwrapped, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBufferUnwrapped)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBufferUnwrapped), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }
        
        context.translateBy(x: 0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBufferUnwrapped, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBufferUnwrapped
    }
    
    
}
