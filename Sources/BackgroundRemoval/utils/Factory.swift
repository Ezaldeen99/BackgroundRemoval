//
//  Factory.swift
//  Background removal
//
//  Created by Ezaldeen99 on 16/03/2022.
//

import Foundation
import SwiftUI

import VideoToolbox

extension UIImage {
    /// resize image first to deal with the model constraints 320*320 images only
    func resizeImage(width: CGFloat, height: CGFloat) -> UIImage {

        let scale = width / self.size.width
        let heightScale = height / self.size.height

        let newHeight = self.size.height * heightScale
        let newWidth = self.size.width * scale

        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit

        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height

            switch self {
            case .aspectFill:
               return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }

    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero

        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0

        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)

        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return scaledImage!
    }
    
    /// the model result mask is white path, we need to invert it first before we mask to get the results
    func invertedImage() -> UIImage? {
           guard let cgImage = self.cgImage else { return nil }
           let ciImage = CoreImage.CIImage(cgImage: cgImage)
           guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
           filter.setDefaults()
           filter.setValue(ciImage, forKey: kCIInputImageKey)
           let context = CIContext(options: nil)
           guard let outputImage = filter.outputImage else { return nil }
           guard let outputImageCopy = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
           return UIImage(cgImage: outputImageCopy, scale: self.scale, orientation: .up)
       }
    
  
    
    /// mask the input image with our mask to get the final result
    func maskImage(withMask maskImage: UIImage) -> UIImage {
        
        let maskRef = maskImage.cgImage

        let mask = CGImage(
            maskWidth: maskRef!.width,
            height: maskRef!.height,
            bitsPerComponent: maskRef!.bitsPerComponent,
            bitsPerPixel: maskRef!.bitsPerPixel,
            bytesPerRow: maskRef!.bytesPerRow,
            provider: maskRef!.dataProvider!,
            decode: nil,
            shouldInterpolate: false)

        let masked = self.cgImage!.masking(mask!)
        let maskedImage = UIImage(cgImage: masked!)

        // No need to release. Core Foundation objects are automatically memory managed.
        return maskedImage

    }
    
    
  
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

        guard let cgImage = cgImage else {
            return nil
        }

        self.init(cgImage: cgImage)
    }

}
