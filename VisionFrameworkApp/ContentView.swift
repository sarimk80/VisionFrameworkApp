//
//  ContentView.swift
//  VisionFrameworkApp
//
//  Created by sarim khan on 22/07/2023.
//

import SwiftUI
import Vision

enum ImageVisonEnum: String, CaseIterable,Identifiable{
case ImageClassification
    case ImageSaliency
    case ImageAlignment
    case ImageSimilarity
    case ObjectDetection
    case ObjectTracking
    case TrajectoryDetection
    case ContourDetection
    case TextDetection
    case TextRecognition
    case FaceDetection
    case FaceTracking
    case FaceLandmarks
    case FaceCaptureQuality
    case HumanBodyDetection
    case BodyPose
    case HandPose
    case AnimalRecognition
    case BarcodeDetection
    case RectangleDetection
    case HorizonDetection
    case OpticalFlow
    case PersonSegmentation
    case DocumentDetection
    
    var id:String {
        return self.rawValue
    }
}

struct ContentView: View {
    
    let imageVison = [
        "Image Classification","Image Saliency","Image Alignment",
        "Image Similarity","Object Detection","Object Tracking",
        "Trajectory Detection","Contour Detection","Text Detection",
        "Text Recognition","Face Detection","Face Tracking",
        "Face Landmarks","Face Capture Quality","Human Body Detection",
        "Body Pose","Hand Pose","Animal Recognition",
        "Barcode Detection","Rectangle Detection","Horizon Detection",
        "Optical Flow","Person Segmentation","Document Detection"
    ]
    
    @State private var imageVisonEnum:ImageVisonEnum = ImageVisonEnum.ImageClassification
    
    
    var body: some View {
        
#if os(macOS)
        NavigationSplitView {
            List(ImageVisonEnum.allCases, selection: $imageVisonEnum) { value in
                Text(value.rawValue)
                    .padding()
                    .onTapGesture {
                        self.imageVisonEnum = value
                    }
            }
            .listStyle(.sidebar)
            .navigationTitle("Image Vison")
        } detail: {
            switch imageVisonEnum {
            case .ImageClassification:
                ImageClassificationView(navTitle: imageVison[0])
            case .ImageSaliency:
                ImageSaliencyView()
            case .ImageAlignment:
                ImageAlignmentView()
            case .ImageSimilarity:
                Text(imageVison[3])
            case .ObjectDetection:
                Text(imageVison[4])
            case .ObjectTracking:
                Text(imageVison[5])
            case .TrajectoryDetection:
                Text(imageVison[6])
            case .ContourDetection:
                Text(imageVison[7])
            case .TextDetection:
                Text(imageVison[8])
            case .TextRecognition:
                Text(imageVison[9])
            case .FaceDetection:
                Text(imageVison[10])
            case .FaceTracking:
                Text(imageVison[11])
            case .FaceLandmarks:
                Text(imageVison[12])
            case .FaceCaptureQuality:
                Text(imageVison[13])
            case .HumanBodyDetection:
                Text(imageVison[14])
            case .BodyPose:
                Text(imageVison[15])
            case .HandPose:
                Text(imageVison[16])
            case .AnimalRecognition:
                Text(imageVison[17])
            case .BarcodeDetection:
                Text(imageVison[18])
            case .RectangleDetection:
                Text(imageVison[19])
            case .HorizonDetection:
                Text(imageVison[20])
            case .OpticalFlow:
                Text(imageVison[21])
            case .PersonSegmentation:
                Text(imageVison[22])
            case .DocumentDetection:
                Text(imageVison[23])
            }
        }
        
#endif
        
        
#if os(iOS)
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
                        ImageSaliencyView()
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
        
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
