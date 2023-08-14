//
//  ImageTextRequestView.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 13/08/2023.
//

import SwiftUI

struct ImageTextRequestView: View {
    
    @StateObject private var iTVN = ImageTextRequestViewModel()
    
    var body: some View {
        VStack{
            Image(nsImage: NSImage(imageLiteralResourceName: "receipt_1"))
                .resizable()
                .frame(width: 300,height: 400)
            List(iTVN.extractedText,id: \.self){value in
                
                Text(value)
            }
        }
        .onAppear{
            iTVN.extractText(image: NSImage(imageLiteralResourceName: "receipt_1"))
        }
    }
}

struct ImageTextRequestView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextRequestView()
    }
}
