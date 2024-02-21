//
//  ContentView.swift
//  CoreMLTests
//
//  Created by Guilherme Nunes Lobo on 21/02/24.
//

import SwiftUI
import Vision
import CoreML


struct ContentView: View {
    @StateObject private var viewModel = ImageClassificationViewModel()
    @State private var isCameraPresented: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Analyse Fruits")
                    .font(.title)
                    .foregroundColor(.primary)
                    .padding()
                
                Spacer()
                Button(action: {
                    isCameraPresented.toggle()
                }) {
                    Text("Open Camera")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
                .sheet(isPresented: $isCameraPresented) {
                    CameraView(viewModel: viewModel, isPresented: $isCameraPresented)
                }

                if let result = viewModel.classificationResult {
                    Text(result)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding()
                }

                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
