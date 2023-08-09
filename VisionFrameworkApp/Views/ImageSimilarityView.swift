//
//  ImageSimilarityView.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 07/08/2023.
//

import SwiftUI

struct ImageSimilarityView: View {
    
    @StateObject private var imageSimilarityVM = ImageSimilarityViewModel()
    
    var body: some View {
        VStack {
            HStack{
                Image(nsImage: NSImage(imageLiteralResourceName: "city_1"))
                    .resizable()
                    .frame(width: 300,height: 400)
                Image(nsImage: NSImage(imageLiteralResourceName: "city_2"))
                    .resizable()
                    .frame(width: 300,height: 400)
            }
            
            Text(imageSimilarityVM.distance.debugDescription)
                .font(.title)
            
        }
        .onAppear{
            imageSimilarityVM.compareImages(image_1: NSImage(imageLiteralResourceName: "city_1"), image_2: NSImage(imageLiteralResourceName: "city_2"))
        }
    }
}

struct ImageSimilarityView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSimilarityView()
    }
}
