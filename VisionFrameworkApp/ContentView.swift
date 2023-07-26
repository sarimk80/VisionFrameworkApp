//
//  ContentView.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 22/07/2023.
//

import SwiftUI
import Vision

struct ContentView: View {
    
    let imageVison = [
        "Image Classification","Image Saliency","Image Alignment",
        "Image Similarity","Object Detection","Object Tracking",
        "Trajectory Detection","Contour Detection","Text Detection",
        "Text Recognition","Face Detection","Face Tracking",
        "Face Landmarks","Face Capture Quality","Human Body Detection",
        "Body Pose","Hand Pose","Animal Recognition",
        "Barcode Detection","Rectangle Detection","Horizon Detection",
        "Optical Flow","Person Segmentation","Document Detection "
    ]
    
    
    var body: some View {
        NavigationView {
            List {
                
                Group {
                    NavigationLink {
                        ImageClassificationView(navTitle: imageVison[0])
                    } label: {
                        Text(imageVison[0])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[1])
                    } label: {
                        Text(imageVison[1])
                            .padding()
                    }
                    NavigationLink {
                        Text(imageVison[2])
                    } label: {
                        Text(imageVison[2])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[3])
                    } label: {
                        Text(imageVison[3])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[4])
                    } label: {
                        Text(imageVison[4])
                            .padding()
                    }
                    
                    
                }
                
               
                Group {
                    NavigationLink {
                        Text(imageVison[5])
                    } label: {
                        Text(imageVison[5])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[6])
                    } label: {
                        Text(imageVison[6])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[7])
                    } label: {
                        Text(imageVison[7])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[8])
                    } label: {
                        Text(imageVison[8])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[9])
                    } label: {
                        Text(imageVison[9])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[10])
                    } label: {
                        Text(imageVison[10])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[11])
                    } label: {
                        Text(imageVison[11])
                            .padding()
                    }
                }
                
                Group {
                    NavigationLink {
                        Text(imageVison[12])
                    } label: {
                        Text(imageVison[12])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[13])
                    } label: {
                        Text(imageVison[13])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[14])
                    } label: {
                        Text(imageVison[14])
                            .padding()
                    }
                    
                    
                    NavigationLink {
                        Text(imageVison[15])
                    } label: {
                        Text(imageVison[15])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[16])
                    } label: {
                        Text(imageVison[16])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[17])
                    } label: {
                        Text(imageVison[17])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[18])
                    } label: {
                        Text(imageVison[18])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[19])
                    } label: {
                        Text(imageVison[19])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[20])
                    } label: {
                        Text(imageVison[20])
                            .padding()
                    }
                }
                
                
                Group {
                    NavigationLink {
                        Text(imageVison[21])
                    } label: {
                        Text(imageVison[21])
                            .padding()
                    }
                    
                    NavigationLink {
                        Text(imageVison[22])
                    } label: {
                        Text(imageVison[22])
                            .padding()
                    }
                    NavigationLink {
                        Text(imageVison[23])
                    } label: {
                        Text(imageVison[23])
                            .padding()
                    }
                }
    
                
            }
            .listStyle(.plain)
            .navigationTitle("Vision")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
