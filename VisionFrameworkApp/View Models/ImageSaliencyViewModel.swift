// ImageSaliencyViewModel.swift
//
// This class is responsible for analyzing an input UIImage using the Vision framework's VNGenerateAttentionBasedSaliencyImageRequest to generate a saliency map and extract salient object's bounding box points. The resulting points (topLeft, topRight, bottomLeft, bottomRight) are then used to draw a rectangle around the salient object on the original image.
//
// Created by Sarim Khan on 28/07/2023.

import Foundation
import Combine
import Vision
import VisionKit

#if os(macOS)
import AppKit
#endif

class ImageSaliencyViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // The four corner points of the salient object's bounding box
    @Published var topLeft: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @Published var topRight: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @Published var bottomLeft: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @Published var bottomRight: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    // The resulting custom UIImage with the saliency map drawn as a rectangle around the salient object
#if os(iOS)
    @Published var customUiImage: UIImage?
#endif
    
#if os(macOS)
    @Published var customNSImage: NSImage?
#endif
    // MARK: - Private Properties
    
    // A set to store the cancellables for Combine subscriptions
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Image Analysis
    
    /// Analyzes the given UIImage to generate the saliency map and extract the salient object's bounding box points.
    /// - Parameter uiImage: The input UIImage to be analyzed.
    func analyzeImage(image: Any) {
        
#if os(iOS)
        let uiImage = image as? UIImage
        // Resize the image to a fixed size for better processing
        let resizeImage = uiImage.resizeImageTo(size: CGSize(width: 227, height: 227))
        
        // Convert the UIImage to a CIImage
        guard let ciImage = CIImage(image: resizeImage!) else { return }
        
        // Create a VNImageRequestHandler with the CIImage
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
#endif
        
#if os(macOS)
        let nsImage = image as? NSImage
        
        let resizeNSImage = nsImage?.resized(to: NSSize(width: 227, height: 227))
        
        let cgImage = resizeNSImage!.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let ciImage = CIImage(cgImage: cgImage!)
        
        let nsRequestHandler = VNImageRequestHandler(ciImage: ciImage,orientation: .up)
        
#endif
        
        
        
        // Create a VNGenerateAttentionBasedSaliencyImageRequest
        let request = VNGenerateAttentionBasedSaliencyImageRequest()
        request.revision = VNGenerateAttentionBasedSaliencyImageRequestRevision1
        
        // Use CPU-only mode for simulator to improve performance
#if targetEnvironment(simulator)
        request.usesCPUOnly = true
#endif
        
        do {
#if os(iOS)
            // Perform the request to generate the saliency map
            try requestHandler.perform([request])
            
#endif
            
#if os(macOS)
            try nsRequestHandler.perform([request])
#endif
            
            // Retrieve the saliency image observation
            guard let observation = request.results?.first as? VNSaliencyImageObservation else { return }
            
            // Extract the pixel buffer from the saliency image observation
            let cvPixelBuffer = observation.pixelBuffer
            
            // Convert the CVPixelBuffer to a custom UIImage and update the customUiImage
            appendCvPixelBuffer(pixelBuffer: cvPixelBuffer)
            
            // Extract and update the bounding box points of the salient object
            observation.salientObjects?.first.map({ rectangle in
                appendCGPoints(vnRectangleObservation: rectangle)
            })
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Combine Publishers
    
    /// Appends the custom UIImage to the published variable customUiImage.
    /// - Parameter pixelBuffer: The CVPixelBuffer to be converted to a custom UIImage.
    func appendCvPixelBuffer(pixelBuffer: CVPixelBuffer) {
        Just(pixelBuffer)
            .receive(on: DispatchQueue.main)
            .sink { cvPixelBuffer in
#if os(iOS)
                self.customUiImage = self.convertPixelBufferToUIImage(pixelBuffer: cvPixelBuffer)
#endif
                
#if os(macOS)
                self.customNSImage = self.convertPixelBufferToNSImage(pixelBuffer: cvPixelBuffer)
#endif
            }
            .store(in: &cancellable)
    }
    
    /// Appends the bounding box points to the published variables topLeft, topRight, bottomLeft, and bottomRight.
    /// - Parameter vnRectangleObservation: The VNRectangleObservation containing the bounding box points of the salient object.
    func appendCGPoints(vnRectangleObservation: VNRectangleObservation) {
        Just(vnRectangleObservation)
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.topLeft = value.topLeft
                self.topRight = value.topRight
                self.bottomRight = value.bottomRight
                self.bottomLeft = value.bottomLeft
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Image Conversion
    
    /// Converts a given CVPixelBuffer to a UIImage.
    /// - Parameter pixelBuffer: The CVPixelBuffer to be converted.
    /// - Returns: The converted UIImage, or nil if the conversion fails.
#if os(iOS)
    func convertPixelBufferToUIImage(pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }
#endif
    
#if os(macOS)
    func convertPixelBufferToNSImage(pixelBuffer: CVPixelBuffer) -> NSImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        // Get the CGImage from the CIImage
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        // Create the NSImage from the CGImage
        let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: CVPixelBufferGetWidth(pixelBuffer),
                                                             height: CVPixelBufferGetHeight(pixelBuffer)))
        
        return nsImage
    }
#endif
}

