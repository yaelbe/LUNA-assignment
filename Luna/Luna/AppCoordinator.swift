//
//  AppCoordinator.swift
//  Luna
//
//  Created by yael bilu eran on 17/06/2023.
//

import Combine
import SwiftUI
import AVFoundation

class AppCoordinator: ObservableObject {
    @Published var isSetupStarted = false
    
    private var cancellables = Set<AnyCancellable>()
    let phonePositionViewModel = PhonePositionViewModel()
    let faceDetectionViewModel = FaceDetectionViewModel()
    
    init() {
        phonePositionViewModel.$isPhonePositionedCorrectly
            .sink { [weak self] isPhonePositionedCorrectly in
                if isPhonePositionedCorrectly {
                    self?.faceDetectionViewModel.startFaceDetection()
                }
            }
            .store(in: &cancellables)
        
    }
    
    func startSetup() {
        checkCameraPermission { granted in
            DispatchQueue.main.async {
                if !granted {
                    self.isSetupStarted = false
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        let alertController = UIAlertController(
                            title: "Camera Access",
                            message: "Please allow access to the camera in Settings to proceed.",
                            preferredStyle: .alert
                        )
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        window.rootViewController?.present(alertController, animated: true)
                    }
                } else {
                    self.isSetupStarted = true
                    self.phonePositionViewModel.startPhonePositionCheck()
                }
            }
        }
    }
    
    func stopSetup() {
        isSetupStarted = false
        phonePositionViewModel.reset()
        faceDetectionViewModel.reset()
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}

