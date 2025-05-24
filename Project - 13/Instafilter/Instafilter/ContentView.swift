//
//  ContentView.swift
//  Instafilter
//
//  Created by Jay Ramirez on 1/28/25.
//

import CoreImage /// Note: CoreImage & CoreImage.CIFilterBuiltins bring in the built in filters
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit // Allows user to leave a review
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var scaleAmount = 0.5 /// Challenge #2
    @State private var widthAmount = 0.5 /// Challenge #2
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingConfirmationDialog = false
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                        .disabled(processedImage == nil ? true : false) /// Challenge #1
                }
                
                HStack {
                    Text("Scale") /// Challenge #1
                    Spacer()
                    Slider(value: $scaleAmount)
                        .onChange(of: scaleAmount, applyProcessing)
                        .disabled(processedImage == nil ? true : false)
                }
                HStack {
                    Text("Width") /// Challenge #1
                    Spacer()
                    Slider(value: $widthAmount)
                        .onChange(of: widthAmount, applyProcessing)
                        .disabled(processedImage == nil ? true : false)
                }
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(processedImage == nil ? true : false) /// Challenge #1
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingConfirmationDialog) {
                Button("Crystallize") { setFilter(CIFilter.crystallize() )}
                Button("Dotscreen") { setFilter(CIFilter.dotScreen()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur() )}
                Button("Pixellate") { setFilter(CIFilter.pixellate() )}
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone() )}
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask() )}
                Button("X-Ray") { setFilter(CIFilter.xRay() )} /// Challenge #3
                Button("Vignette") { setFilter(CIFilter.vignette() )} /// Challenge #3
                Button("Circularscreen") { setFilter(CIFilter.circularScreen() )}
                Button("Cancel", role: .cancel) { }
                
            }
        }
    }
    
    func changeFilter() {
        showingConfirmationDialog = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(scaleAmount * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputWidthKey) { currentFilter.setValue(widthAmount * 10, forKey: kCIInputWidthKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        
        if filterCount % 10 == 1 {
            requestReview()
        }
    }
}


#Preview {
    ContentView()
}
