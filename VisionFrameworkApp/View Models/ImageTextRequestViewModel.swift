/**
 ImageTextRequestViewModel.swift
 VisionFrameworkApp

 Created by Sarim Khan on 13/08/2023.
 */

import Foundation
import Combine
import Vision
import VisionKit
import AppKit

/**
 A view model class responsible for text extraction from images using the Vision framework.
 
 This class uses the Vision framework to extract text from an input NSImage and publishes the extracted text using Combine.
 */
class ImageTextRequestViewModel: ObservableObject {
    
    /// Published property to store the extracted text.
    @Published var extractedText: [String] = []
    
    /// Set to manage Combine cancellable objects.
    private var cancellable = Set<AnyCancellable>()
    
    /**
     Extracts text from an input NSImage using the Vision framework.
     
     - Parameters:
       - image: The NSImage from which text will be extracted.
     */
    func extractText(image: NSImage) {
        // Convert NSImage to CGImage
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        
        // Create a text recognition request
        let textRequest = VNRecognizeTextRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            // Perform the text recognition request
            try handler.perform([textRequest])
            
            // Process the recognition results
            let result = textRequest.results
            result?.forEach { text in
                populateText(text: text.topCandidates(1).first?.string ?? "")
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /**
     Populates the extracted text array and publishes the value using Combine.
     
     - Parameter text: The text to be added to the extractedText array.
     */
    func populateText(text: String) {
        Just(text)
            .receive(on: DispatchQueue.main)
            .sink { value in
                // Append the extracted text to the array
                self.extractedText.append(value)
            }
            .store(in: &cancellable)
    }
}

