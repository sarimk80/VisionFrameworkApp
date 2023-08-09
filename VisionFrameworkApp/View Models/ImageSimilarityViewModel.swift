//
//  ImageSimilarityViewModel.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 07/08/2023.
//

import Foundation
import Combine
import Vision
import VisionKit
import AppKit

class ImageSimilarityViewModel:ObservableObject{
    
    @Published var distance:Float = 0.0
    private var cancellable = Set<AnyCancellable>()
    
    
    /**
     Generate Feature Print Observation for an NSImage.
     
     - Parameter nsImage: The NSImage to generate the feature print for.
     - Returns: A `VNFeaturePrintObservation` object representing the feature print of the image.
     */
    func imageFeaturePrint(nsImage: NSImage) -> VNFeaturePrintObservation? {
        // Create a request for generating a feature print observation
        let request = VNGenerateImageFeaturePrintRequest()
        
        // Create a request handler for the provided NSImage
        let requestHandler = VNImageRequestHandler(cgImage: nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        
        do {
            // Perform the request to generate the feature print observation
            try requestHandler.perform([request])
            
            // Retrieve the generated feature print observation
            let result = request.results?.first as? VNFeaturePrintObservation
            return result
        } catch let error {
            print("Failed to generate feature print.")
            print(error.localizedDescription)
        }
        return nil
    }

    /**
     Compare Images using their Feature Prints.
     
     - Parameters:
        - image_1: The first NSImage to be compared.
        - image_2: The second NSImage to be compared.
     */
    func compareImages(image_1: NSImage, image_2: NSImage) {
        // Generate feature print observations for the provided images
        guard let firstImage = imageFeaturePrint(nsImage: image_1),
              let secondImage = imageFeaturePrint(nsImage: image_2) else { return }

        var distance = Float(0)
        
        do {
            // Compute the similarity distance between the feature prints
            try firstImage.computeDistance(&distance, to: secondImage)
            print("Image similarity distance: \(distance)")
            populateFields(value: distance)
        } catch let error {
            print("Image comparison error.")
            print(error.localizedDescription)
        }
    }

    
    func populateFields(value:Float){
        Just(value)
            .receive(on: DispatchQueue.main)
            .sink { data in
                self.distance = data
            }
            .store(in: &cancellable)
        
    }
    
    
}
