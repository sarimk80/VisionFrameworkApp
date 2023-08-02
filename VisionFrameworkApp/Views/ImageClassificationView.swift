//
//  ImageClassificationView.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 24/07/2023.
//

import SwiftUI
import PhotosUI

#if os(macOS)
import AppKit
#endif

struct ImageClassificationView: View {
    
    @StateObject private var icViewModel = ImageClassificationViewModel()
    
    var navTitle:String
    var body: some View {
        VStack(spacing: 16) {
            
            #if os(iOS)
            Image(uiImage: icViewModel.uiImage ?? UIImage(imageLiteralResourceName: "book"))
                .resizable()
                .frame(width:300,height:400)
                .cornerRadius(15)
            #endif
            
            #if os(macOS)
            Image(nsImage:icViewModel.nsImage ?? NSImage(imageLiteralResourceName: "book"))
                .resizable()
                .frame(width:300,height:400)
                .cornerRadius(15)
            #endif
            
            
            
            
            PhotosPicker("Select photo", selection: $icViewModel.photoPickerItem,matching: .all(of: [.images]))
            
            Button {
                #if os(iOS)
                icViewModel.classifyImage(image:icViewModel.uiImage ?? UIImage(imageLiteralResourceName: "house"))
                
                icViewModel.classifyImageMLCore(image: icViewModel.uiImage ?? UIImage(imageLiteralResourceName: "house"))
                #endif
                
                #if os(macOS)
                icViewModel.classifyImage(image:icViewModel.nsImage ?? NSImage(imageLiteralResourceName: "house"))
                
                icViewModel.classifyImageMLCore(image: icViewModel.nsImage ?? NSImage(imageLiteralResourceName: "house"))
                #endif
                
                
            } label: {
                Text("Classify Image")
                    
                    .foregroundColor(.yellow)
                    .cornerRadius(8)
            }
            .buttonStyle(.bordered)

            Text(icViewModel.imageClassificationText.first ?? "")
            Text(icViewModel.imageClassificationText.last ?? "")
            
            
        }
        .onChange(of: icViewModel.photoPickerItem, perform: { newValue in
            Task {
                do{
                    
                    let data = try await icViewModel.photoPickerItem?.loadTransferable(type: Data.self)
                    
                    guard let unwrapData = data else {
                        print("Error")
                        return
                        
                    }
                    
                    #if os(iOS)
                    icViewModel.uiImage = UIImage(data: unwrapData)
                    #endif
                    
                    #if os(macOS)
                    icViewModel.nsImage = NSImage(data: unwrapData)
                    #endif

                }catch let error{
                    print(error.localizedDescription)
                }
                
            }
        })
        .navigationTitle("Image Classification")
        
    }
}

struct ImageClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        ImageClassificationView(navTitle: "Image Classification")
    }
}
