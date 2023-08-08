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
    
    
    func imageSimilarity(nsImage: NSImage) -> VNFeaturePrintObservation?{
        
        let request = VNGenerateImageFeaturePrintRequest()
        
        let requestHandler = VNImageRequestHandler(cgImage: nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        
        do{
            
            try requestHandler.perform([request])
            
            let result = request.results?.first as? VNFeaturePrintObservation
            
            return result
            
        }catch let error{
            print("Falied")
            print(error.localizedDescription)
        }
        return nil
    }
    
    func compareImages(image_1:NSImage,image_2:NSImage){
                
        guard let firstImage = imageSimilarity(nsImage: image_1) else { return }
        guard let secondImage = imageSimilarity(nsImage: image_2) else { return }
    
        var distance = Float(0)
        
        do{
            
            try firstImage.computeDistance(&distance, to: secondImage)
            
            print(distance)
            
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    
}
