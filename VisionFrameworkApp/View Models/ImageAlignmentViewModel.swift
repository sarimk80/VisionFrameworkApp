//
//  ImageAlignmentViewModel.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 01/08/2023.
//

import Foundation
import Combine
import Vision
import VisionKit
import AppKit
import CoreImage


class ImageAlignmentViewModel:ObservableObject{
    
    @Published var resultImage:NSImage = NSImage(imageLiteralResourceName: "forest")
    
    private var cancellable = Set<AnyCancellable>()
    
    
    // Function to perform panoramic image alignment using VNTranslationalImageRegistrationRequest.
        func panoramicImage(targetImage: NSImage, refrenceImage: NSImage) {
            // Convert NSImage to CGImage for Vision processing.
            guard let targetCgImage = targetImage.cgImage(forProposedRect: nil, context: nil, hints: nil),
                  let refrenceCgImage = refrenceImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
            
            // Create CIImage objects from CGImage.
            let ciImage = CIImage(cgImage: targetCgImage)
            let ciImageSource = CIImage(cgImage: refrenceCgImage)
            
            // Create VNTranslationalImageRegistrationRequest with the source CIImage and perform the request.
            let imageRegistrationRequest = VNTranslationalImageRegistrationRequest(targetedCIImage: ciImageSource, orientation: .up)
            let vnRequestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            
            do {
                try vnRequestHandler.perform([imageRegistrationRequest])
                
                // Retrieve the translation result from the request and align the source image.
                if let alignment = imageRegistrationRequest.results?.first as? VNImageTranslationAlignmentObservation {
                    let transform = alignment.alignmentTransform
                    let alignImage = ciImageSource.transformed(by: transform, highQualityDownsample: true)
                    
                    // Apply compositing to merge aligned images.
                    let compositImage = alignImage.applyingFilter("CILightenBlendMode", parameters: ["inputBackgroundImage": ciImage])
                    
                    // Update the resultImage with the merged image.
                    appendImage(nsImagealign: convertCIImageToNSImage(ciImage: compositImage)!)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    
    
    func homographicImageRegistrationRequest(targetImage: NSImage,sourceImage:NSImage){
        
        guard let targetCgImage = targetImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return  }
        
        guard let sourceCgImage = sourceImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        
        let request = VNHomographicImageRegistrationRequest(targetedCGImage: targetCgImage)
        
        let handler = VNSequenceRequestHandler()
        
        do{
           try handler.perform([request], on: sourceCgImage)
            
            let observation = request.results?.first as? VNImageHomographicAlignmentObservation
            
            guard let matrix = observation?.warpTransform else {return}
            
            
            let targetCIImage = CIImage(cgImage:targetCgImage)
            
            let affineTransform = CGAffineTransform(
                   a: CGFloat(matrix[0][0]),
                   b: CGFloat(matrix[0][1]),
                   c: CGFloat(matrix[1][0]),
                   d: CGFloat(matrix[1][1]),
                   tx: CGFloat(matrix[2][0]),
                   ty: CGFloat(matrix[2][1])
               )
            
           let transformImage = targetCIImage.transformed(by: affineTransform,highQualityDownsample: true)
            
            //CIAdditionCompositing
            //CISourceOverCompositing
            //CIColorBlendMode
            // CIColorBurnBlendMode
            // CIColorDodgeBlendMode
            //CIExclusionBlendMode
            //CILightenBlendMode
            //CIOverlayBlendMode
            
            let compositImage = transformImage.applyingFilter("CIAdditionCompositing", parameters: ["inputBackgroundImage": CIImage(cgImage: sourceCgImage)])
                            
            
            let newComposit = transformImage.composited(over: CIImage(cgImage: sourceCgImage))
                            
            //let onlyTransformImage = convertCIImageToNSImage(ciImage: alignImage)
            
            appendImage(nsImagealign: convertCIImageToNSImage(ciImage: compositImage)!)
            
            
           
            
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    
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
    
    func appendImage(nsImagealign:NSImage){
        Just(nsImagealign)
            .receive(on: DispatchQueue.main)
            .sink { image in
                self.resultImage = image
            }
            .store(in: &cancellable)
    }
    
    
    func convertCIImageToNSImage(ciImage: CIImage) -> NSImage? {
        let ciContext = CIContext(options: nil)
        if let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) {
            return NSImage(cgImage: cgImage, size: NSSize(width: ciImage.extent.width, height: ciImage.extent.height))
        }
        return nil
    }
    
    
    
}
