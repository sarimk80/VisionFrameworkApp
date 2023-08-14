//
//  ObjectDetectionView.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 09/08/2023.
//

import SwiftUI

struct ObjectDetectionView: View {
    
    @StateObject private var obVM = ObjectDetectionViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                Image(nsImage: NSImage(imageLiteralResourceName: "text_1"))
                    .resizable()
                    .frame(width: 300,height: 400)
                
            }
        }
        .onAppear{
            //obVM.yolo(image: NSImage(imageLiteralResourceName: "book"))
            obVM.detectObject(nsImage: NSImage(imageLiteralResourceName: "text_1"))
        }
    }
}

struct ObjectDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectDetectionView()
    }
}
