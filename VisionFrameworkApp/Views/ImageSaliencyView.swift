//
//  ImageSaliencyView.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 28/07/2023.
//

import SwiftUI




struct ImageSaliencyView: View {
    
    @StateObject private var isViewModel = ImageSaliencyViewModel()
    
    var body: some View {
        VStack {
                
                Image(uiImage: UIImage(imageLiteralResourceName: "house"))
                    .resizable()
                    .frame(width:227,height:227)
                .overlay {
                    GeometryReader { reader in
                        Path{ path in
                            path.move(to: CGPoint(x: isViewModel.topLeft.x * reader.size.width, y: isViewModel.topLeft.y * reader.size.height))
                            path.addLine(to: CGPoint(x: isViewModel.topRight.x * reader.size.width, y: isViewModel.topRight.y * reader.size.height))
                            path.addLine(to: CGPoint(x: isViewModel.bottomRight.x * reader.size.width, y: isViewModel.bottomRight.y * reader.size.height))
                            path.addLine(to: CGPoint(x: isViewModel.bottomLeft.x * reader.size.width, y: isViewModel.bottomLeft.y * reader.size.height))
            
                        }
                        .stroke(.red,style: StrokeStyle(lineWidth: 5,lineCap: .round,lineJoin: .round))
                    }
            
                }
                
            
            
            Image(uiImage: isViewModel.customUiImage ?? UIImage(imageLiteralResourceName: "book"))
                
                
        }
        .navigationTitle("Image Saliency")
        .onAppear{
            isViewModel.analyzeImage(uiImage: UIImage(imageLiteralResourceName: "house")
            )
        }
    }
}

struct ImageSaliencyView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSaliencyView()
    }
}

