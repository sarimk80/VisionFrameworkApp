//
//  ImageClassificationViewModel.swift
//  VisionFrameworkApp
//
//  Created by Sarim Khan on 24/07/2023.
//

import Foundation
import Combine
import Vision
import VisionKit
import SwiftUI
import PhotosUI

#if os(macOS)
import AppKit
#endif

/// View Model for Image Classification
class ImageClassificationViewModel : ObservableObject {
    
    /// The selected item from the photo picker
    @Published var photoPickerItem : PhotosPickerItem? = nil
    
    /// The UIImage representation of the selected image
#if os(iOS)
    @Published var uiImage : UIImage?
#endif
#if os(macOS)
    @Published var nsImage : NSImage?
#endif
    
    /// An array to store the image classification results
    @Published var imageClassificationText: [String] = []
    
    /// Set to hold Combine cancellable objects
    private var cancellable = Set<AnyCancellable>()
    
    /// Classify the given UIImage using Vision framework
    /// - Parameter uiImage: The UIImage to be classified
    func classifyImage(image: Any)  {
        
        self.imageClassificationText.removeAll()
        
        #if os(iOS)
        let uiImage = image as? UIImage
        guard let ciImage = CIImage(image: uiImage) else {
            print("Empty image")
            return
        }
        
        #endif
        
        #if os(macOS)
        let nsImage = image as? NSImage
        let cgImage = nsImage!.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let ciImage = CIImage(cgImage: cgImage!)
        #endif
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        // Create a VNClassifyImageRequest to perform image classification
        let request = VNClassifyImageRequest { request, error in
            
            if let result = request.results as? [VNClassificationObservation] {
                // Append the classification result to the array
                self.appendImageClassification(imageData: "Classification: \(result.first!.identifier) - Confidence: \(result.first!.confidence)")
            }
        }
        
        // Set to true if running on the simulator to use CPU instead of GPU for image classification
#if targetEnvironment(simulator)
        request.usesCPUOnly = true
#endif
        
        do {
            try handler.perform([request])
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    /// Classify the given UIImage using the SqueezeNet Core ML model
    /// - Parameter uiImage: The UIImage to be classified
    func classifyImageMLCore(image: Any) {
        
        
        // Resize the image to the required size for SqueezeNet
        
        #if os(iOS)
        let uiImage = image as? UIImage
        let resizeImage = uiImage.resizeImageTo(size: CGSize(width: 227, height: 227))
        guard let cvPixelBuffer = resizeImage?.convertToBuffer() else { return  }
        #endif
        
        #if os(macOS)
        let nsImage = image as? NSImage
        let resizeImage = nsImage?.resized(to: NSSize(width: 113.5, height: 113.5))
        guard let cvPixelBuffer = resizeImage?.toCVPixelBuffer() else { return  }
        #endif
        
        do {
            // Load the SqueezeNet Core ML model
            let model = try SqueezeNet(configuration: MLModelConfiguration())
            
            // Perform image classification using the model
            let prediction = try model.prediction(image: cvPixelBuffer)
            
            // Append the classification result to the array
            self.appendImageClassification(imageData: prediction.classLabel)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    /// Append the image classification result to the array and update the UI
    /// - Parameter imageData: The image classification result to be appended
    func appendImageClassification(imageData: String) {
        Just(imageData)
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.imageClassificationText.append(value)
            }
            .store(in: &cancellable)
    }
}
