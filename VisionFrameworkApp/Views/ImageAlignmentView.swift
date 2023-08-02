//
//  ImageAlignmentView.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 01/08/2023.
//

import SwiftUI

struct ImageAlignmentView: View {
    
    @StateObject private var imageAlignViewModel = ImageAlignmentViewModel()
    
    var body: some View {
        List {
            Image(nsImage: NSImage(imageLiteralResourceName: "paronamic_2"))
                .resizable()
                .frame(width: 300,height: 400)
            Image(nsImage: NSImage(imageLiteralResourceName: "paronamic_3"))
                .resizable()
                .frame(width: 300,height: 400)
            
            Image(nsImage: imageAlignViewModel.resultImage)
                .resizable()
                .frame(width: 300,height: 400)
        }
        .onAppear{
//            imageAlignViewModel.paronamicImage(targetImage: NSImage(imageLiteralResourceName: "paronamic_2"), refrenceImage: NSImage(imageLiteralResourceName: "paronamic_3"))
            imageAlignViewModel.homographicImageRegistrationRequest(targetImage: NSImage(imageLiteralResourceName: "paronamic_2"), sourceImage: NSImage(imageLiteralResourceName: "paronamic_3"))
        }
            
    }
}

struct ImageAlignmentView_Previews: PreviewProvider {
    static var previews: some View {
        ImageAlignmentView()
    }
}
