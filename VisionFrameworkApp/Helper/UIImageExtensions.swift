//
//  UIImageExtensions.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 25/07/2023.
//

import Foundation
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import AppKit
#endif


#if os(iOS)
extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func convertToBuffer() -> CVPixelBuffer? {
        
        let attributes = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault, Int(self.size.width),
            Int(self.size.height),
            kCVPixelFormatType_32ARGB,
            attributes,
            &pixelBuffer)
        
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(
            data: pixelData,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
#endif


#if os(macOS)

extension NSImage {
    func resized(to newSize: NSSize) -> NSImage {
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        
        let fromRect = NSRect(origin: .zero, size: self.size)
        let toRect = NSRect(origin: .zero, size: newSize)
        self.draw(in: toRect, from: fromRect, operation: .copy, fraction: 1.0)
        
        newImage.unlockFocus()
        return newImage
    }
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        let attributes: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: kCFBooleanTrue!,
        ]
        var pixelBuffer: CVPixelBuffer?
        
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attributes as CFDictionary, &pixelBuffer)
        
        guard let buffer = pixelBuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let context = NSGraphicsContext(cgContext: CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                                             width: width,
                                                             height: height,
                                                             bitsPerComponent: 8,
                                                             bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                                             space: CGColorSpaceCreateDeviceRGB(),
                                                             bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)!, flipped: false)
        
        NSGraphicsContext.current = context
        self.draw(at: NSPoint(x: 0, y: 0), from: NSRect(x: 0, y: 0, width: width, height: height), operation: .copy, fraction: 1.0)
        context.flushGraphics()
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return buffer
    }
}

#endif
