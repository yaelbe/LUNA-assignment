//
//  PhonePositionViewModel.swift
//  Luna
//
//  Created by yael bilu eran on 17/06/2023.
//

import SwiftUI
import Combine
import CoreMotion

class PhonePositionViewModel: ObservableObject {
    @Published var isPhonePositionedCorrectly = false
    @Published var currentAngle: Double = 0.0
    
    private var cancellables = Set<AnyCancellable>()
    private let motionManager = CMMotionManager()
    private var positionStartTime: Date?
    
    func startPhonePositionCheck() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { [weak self] (motion, error) in
            guard let self = self else { return }
            
            if let motion = motion {
                let pitch = motion.attitude.pitch * 180.0 / .pi
                self.currentAngle = abs(pitch)
                
                if self.currentAngle >= 70 && self.currentAngle <= 110 {
                    if self.positionStartTime == nil {
                        self.positionStartTime = Date()
                    }
                    
                    let timeElapsed = Date().timeIntervalSince(self.positionStartTime!)
                    if timeElapsed >= 3 {
                        DispatchQueue.main.async {
                            self.isPhonePositionedCorrectly = true
                        }
                        self.motionManager.stopDeviceMotionUpdates()
                    }
                } else {
                    self.positionStartTime = nil
                    self.isPhonePositionedCorrectly = false
                }
            }
        }
    }
    
    func reset() {
        isPhonePositionedCorrectly = false
        currentAngle = 0.0
        positionStartTime = nil
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}

