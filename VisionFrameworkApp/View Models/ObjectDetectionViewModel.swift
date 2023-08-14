//
//  ObjectDetectionViewModel.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 09/08/2023.
//

import Foundation
import Combine
import Vision
import VisionKit
import AppKit

class ObjectDetectionViewModel: ObservableObject{
    
    @Published var rectangles:[VNRectangleObservation] = []
    private var cancellable = Set<AnyCancellable>()
    
    
    func detectObject(nsImage:NSImage) {
        
        guard let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            
            print("error image to cgImage")
            return
            
        }
        
        let request = VNDetectRectanglesRequest(completionHandler: { observation, error in
            
           
            
        })
        
        //request.revision = VNDetectRectanglesRequestRevision1
//        request.maximumObservations = 8
//        request.minimumConfidence = 0.6 // Be confident.
//        request.minimumAspectRatio = 0.3 // height / width
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        do{
            
            try requestHandler.perform([request])
            
//            guard let observation = request.results else {
//
//                print("error in observation")
//                return
//
//
//            }
//
//
//            observation.forEach { rectangle in
//                print(rectangle.boundingBox.width)
//                print(rectangle.boundingBox.height)
//            }

            
        }catch let error{
            
            print(error.localizedDescription)
        }
        
    }
    
    
    func yolo(image: Any){
        
        
        do{
            
            let nsImage = image as? NSImage
            let resizeImage = nsImage?.resized(to: NSSize(width: 208, height: 208))
            guard let cvPixelBuffer = resizeImage?.toCVPixelBuffer() else { return  }
            
            let model = try YOLOv3(configuration: MLModelConfiguration())
            let prediction = try model.prediction(image: cvPixelBuffer, iouThreshold: 0.95, confidenceThreshold: 0.8)
            
            
            prediction.confidence.shape.forEach { numbers in
                print(numbers.description)
            }
            
            prediction.confidence.shape.forEach { numbers in
                print(numbers.description)
            }
            
            
            
        }catch let error{
            print(error.localizedDescription)
            
        }
        
    }
    
    func populateRectangles(rectangle:VNRectangleObservation){
        Just(rectangle)
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.rectangles.append(value)
            }
            .store(in: &cancellable)
    }
    
}
