//
//  CameraViewController.swift
//  CoreMLTests
//
//  Created by Guilherme Nunes Lobo on 21/02/24.
//

import AVKit
import SwiftUI

struct CameraViewController: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ImageClassificationViewModel
    @Binding var isPresented: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraViewController

        init(parent: CameraViewController) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.viewModel.classifyImage(uiImage)
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
