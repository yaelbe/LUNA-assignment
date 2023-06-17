//
//  FaceDetectionViewModel.swift
//  Luna
//
//  Created by yael bilu eran on 17/06/2023.
//

import SwiftUI
import Combine
import AVFoundation
import Vision

class FaceDetectionViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var isFaceDetected = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func startFaceDetection() {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            return
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        
        guard session.canAddInput(input) else {
            return
        }
        
        session.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "FaceDetectionQueue"))
        
        guard session.canAddOutput(output) else {
            return
        }
        
        session.addOutput(output)
        session.commitConfiguration()
        
        let videoConnection = output.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }
    
    func reset() {
        isFaceDetected = false
    }
    
    deinit {
        AVCaptureDevice.requestAccess(for: .video) { _ in
            AVCaptureDevice.authorizationStatus(for: .video)
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
            if let error = error {
                print("Error in face detection: \(error)")
                return
            }
            
            guard let results = request.results as? [VNFaceObservation], let _ = results.first else {
                DispatchQueue.main.async {
                    self?.isFaceDetected = false
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.isFaceDetected = true
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

