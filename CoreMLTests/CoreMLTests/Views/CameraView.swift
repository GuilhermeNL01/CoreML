//
//  CameraView.swift
//  CoreMLTests
//
//  Created by Guilherme Nunes Lobo on 21/02/24.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel: ImageClassificationViewModel
    @Binding var isPresented: Bool

    var body: some View {
        CameraViewController(viewModel: viewModel, isPresented: $isPresented)
            .edgesIgnoringSafeArea(.all)
    }
}
