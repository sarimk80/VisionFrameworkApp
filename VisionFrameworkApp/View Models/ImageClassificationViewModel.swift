//
//  ImageClassificationViewModel.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 24/07/2023.
//

import Foundation
import Combine
import Vision
import VisionKit
import SwiftUI
import PhotosUI

class ImageClassificationViewModel : ObservableObject {
    
    @Published var photoPickerItem : PhotosPickerItem? = nil
    @Published var uiImage : UIImage?
    @Published var imageClassificationText: [String] = []
    var cancellable=Set<AnyCancellable>()
    
    
    func classifyImage(uiImage:UIImage)  {
        
        guard let ciImage = CIImage(image: uiImage) else {
            
            print("Empty")
            return
            
            
        }
        
        let handler  = VNImageRequestHandler(ciImage: ciImage)
        
        let request = VNClassifyImageRequest { request, error in
            
            if let result = request.results as? [VNClassificationObservation] {
                
                self.appendImageClassification(imageData: "Classification: \(result.first!.identifier) - Confidence: \(result.first!.confidence)")
                 
            }
        }
#if targetEnvironment(simulator)
        request.usesCPUOnly = true
#endif
        
        
        do{
            try handler.perform([request])
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    func classifyImageMLCore(uiImage:UIImage) {
        
        let resizeImage = uiImage.resizeImageTo(size: CGSize(width: 227, height: 227))
        guard let cvPixelBuffer = resizeImage?.convertToBuffer() else { return  }
        
        do{
            let model  = try SqueezeNet(configuration: MLModelConfiguration())
            let prediction = try model.prediction(image: cvPixelBuffer)
            self.appendImageClassification(imageData: prediction.classLabel)
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    func appendImageClassification(imageData:String){
        Just(imageData)
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.imageClassificationText.append(value)
            }
            .store(in: &cancellable)
    }
}
