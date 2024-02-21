//
//  ContentView.swift
//  CoreMLTests
//
//  Created by Guilherme Nunes Lobo on 21/02/24.
//

import SwiftUI
import Vision
import CoreML
import CoreImage
import AVKit

struct ContentView: View {
    @State private var isCameraPresented: Bool = false
    @State private var classificationResult: String?

    var body: some View {
        VStack {
            Button("Open Camera") {
                isCameraPresented.toggle()
            }
            .padding()
            .sheet(isPresented: $isCameraPresented) {
                CameraView(isPresented: $isCameraPresented, onCapture: { image in
                    classifyImage(image)
                })
            }

            if let result = classificationResult {
                Text("Result: \(result)")
                    .padding()
            }
        }
    }

    func classifyImage(_ image: UIImage) {
        guard let model = try? VNCoreMLModel(for: FrutinhasML().model) else {
            fatalError("Failed to load Core ML model")
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNClassificationObservation] {
                if let firstResult = results.first {
                    classificationResult = "Label: \(firstResult.identifier), Confidence: \(firstResult.confidence)"
                } else {
                    classificationResult = "No results found"
                }
            } else if let error = error {
                classificationResult = "Error: \(error.localizedDescription)"
            }
        }

        if let cgImage = image.cgImage {
            let handler = VNImageRequestHandler(cgImage: cgImage)
            do {
                try handler.perform([request])
            } catch {
                print("Error performing classification: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CameraView: View {
    @Binding var isPresented: Bool
    var onCapture: (UIImage) -> Void

    var body: some View {
        CameraViewController(isPresented: $isPresented, onCapture: onCapture)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CameraViewController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onCapture: (UIImage) -> Void

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraViewController

        init(parent: CameraViewController) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.onCapture(uiImage)
            }

            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> UIImagePickerController {
        let cameraController = UIImagePickerController()
        cameraController.delegate = context.coordinator
        cameraController.sourceType = .camera
        return cameraController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraViewController>) {
        // No update needed
    }
}

#Preview {
    ContentView()
}
