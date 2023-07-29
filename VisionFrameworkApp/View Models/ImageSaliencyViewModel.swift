//
//  ImageSaliencyViewModel.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 28/07/2023.
//

import Foundation
import Combine
import Vision
import VisionKit


//switch SaliencyType(rawValue: UserDefaults.standard.saliencyType)! {
//    case .attentionBased:
//        request = VNGenerateAttentionBasedSaliencyImageRequest()
//    case .objectnessBased:
//        request = VNGenerateObjectnessBasedSaliencyImageRequest()
//}


class ImageSaliencyViewModel: ObservableObject{
    
    @Published var topLeft:CGPoint = CGPoint(x: 0.0, y: 0.0)
    @Published var topRight:CGPoint = CGPoint(x: 0.0, y: 0.0)
    @Published var bottomLeft:CGPoint = CGPoint(x: 0.0, y: 0.0)
    @Published var bottomRight:CGPoint = CGPoint(x: 0.0, y: 0.0)
    @Published var customUiImage:UIImage?
    
    private var cancellable = Set<AnyCancellable>()
    
    func analyzeImage(uiImage:UIImage){
        
        let resizeImage = uiImage.resizeImageTo(size: CGSize(width: 227, height: 227))
        
        guard let ciImage = CIImage(image: resizeImage!) else { return  }
        
        let requestHandler = VNImageRequestHandler(ciImage: ciImage,orientation: .up)
        
        let request = VNGenerateAttentionBasedSaliencyImageRequest()
        
        request.revision = VNGenerateAttentionBasedSaliencyImageRequestRevision1
        
        #if targetEnvironment(simulator)
        request.usesCPUOnly = true
        #endif
        
        do{
            try requestHandler.perform([request])
            
            guard let observation = request.results?.first as? VNSaliencyImageObservation else { return }
            
            let cvPizelBuffer =  observation.pixelBuffer
                        
            appendCvPixelBuffer(pixelBuffer: cvPizelBuffer)
            observation.salientObjects?.first.map({ rectangle in
                print("Single of rectangles")
                appendCGPoints(vnRectangleObservation: rectangle)
                print(rectangle.bottomLeft)
                print(rectangle.bottomRight)
                print(rectangle.topLeft)
                print(rectangle.topRight)

            })
            
            
            
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func appendCvPixelBuffer(pixelBuffer:CVPixelBuffer){
        
        Just(pixelBuffer)
            .receive(on: DispatchQueue.main)
            .sink { cvPixelBuffer in
                self.customUiImage = self.convertPixelBufferToUIImage(pixelBuffer: cvPixelBuffer)
            }
            .store(in: &cancellable)
    }
    
    func appendCGPoints(vnRectangleObservation:VNRectangleObservation){
        
        Just(vnRectangleObservation)
            .receive(on: DispatchQueue.main)
            .sink{ value  in
                
                self.topLeft = value.topLeft
                self.topRight = value.topRight
                self.bottomRight = value.bottomRight
                self.bottomLeft = value.bottomLeft
                
            }
            .store(in: &cancellable)
    }
    
    func convertPixelBufferToUIImage(pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }
}
