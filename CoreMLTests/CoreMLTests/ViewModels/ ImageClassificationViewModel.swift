//
//   ImageClassificationViewModel.swift
//  CoreMLTests
//
//  Created by Guilherme Nunes Lobo on 21/02/24.
//

import SwiftUI
import Vision
import CoreML

class ImageClassificationViewModel: ObservableObject {
    @Published var classificationResult: String?

    func classifyImage(_ image: UIImage) {
        guard let model = try? VNCoreMLModel(for: FrutinhasML().model) else {
            fatalError("Failed to load Core ML model")
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNClassificationObservation] {
                if let firstResult = results.first {
                    self.classificationResult = "Label: \(firstResult.identifier)\nConfidence: \(String(format: "%.2f", firstResult.confidence * 100))%"
                } else {
                    self.classificationResult = "No results found"
                }
            } else if let error = error {
                self.classificationResult = "Error: \(error.localizedDescription)"
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
