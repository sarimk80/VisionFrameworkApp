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
            
            
            CustomOverLayImage(isViewModel: isViewModel)
            
            CustomImage(isViewModel: isViewModel)
            
            
        }
        .navigationTitle("Image Saliency")
        .onAppear{
#if os(iOS)
            isViewModel.analyzeImage(image: UIImage(imageLiteralResourceName: "house")
            )
#endif
            
#if os(macOS)
            isViewModel.analyzeImage(image: NSImage(imageLiteralResourceName: "house"))
#endif
        }
    }
}

struct CustomImage: View {
    
    @ObservedObject  var isViewModel: ImageSaliencyViewModel
    
    var body: some View {
        
#if os(iOS)
        
        Image(uiImage: isViewModel.customUiImage ?? UIImage(imageLiteralResourceName: "house"))
            .resizable()
            .frame(width:227,height:227)
        
#endif
        
#if os(macOS)
        Image(nsImage: isViewModel.customNSImage ?? NSImage(imageLiteralResourceName: "house"))
            .resizable()
            .frame(width:227,height:227)
#endif
    }
}



struct CustomOverLayImage: View {
    
    @ObservedObject   var isViewModel:ImageSaliencyViewModel
    
    var body: some View {
        
#if os(iOS)
        Image(uiImage: UIImage(imageLiteralResourceName: "house"))
            .resizable()
            .modifier(ImageBoxModifier(isViewModel: $isViewModel))
#endif
        
#if os(macOS)
        Image(nsImage: NSImage(imageLiteralResourceName: "house"))
            .resizable()
            .modifier(ImageBoxModifier(isViewModel: isViewModel))
#endif
        
        
        
    }
}

struct ImageBoxModifier: ViewModifier {
    
    @ObservedObject  var isViewModel: ImageSaliencyViewModel
    
    func body(content: Content) -> some View {
        content
        
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
    }
}

struct ImageSaliencyView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSaliencyView()
    }
}

