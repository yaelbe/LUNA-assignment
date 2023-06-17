import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some View {
        VStack {
            Text("Refraction Exam Setup Guide")
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Spacer()
            
            if !appCoordinator.isSetupStarted {
                Text("""
                    For this setup you need to pass two instructions in the guide:
                    
                    1. Position the phone at 70 -110 °
                    2. Position your face in front of the camera
                    """)
                .font(.subheadline)
                .padding()
            }
            
            if appCoordinator.isSetupStarted {
                if !appCoordinator.phonePositionViewModel.isPhonePositionedCorrectly {
                    Text("Position the phone at the correct angle (70-110 degrees).")
                        .font(.headline)
                        .padding()
                    Text("Current Angle: \(appCoordinator.phonePositionViewModel.currentAngle, specifier: "%.1f")°")
                        .font(.headline)
                        .padding()
                }
                
                if appCoordinator.phonePositionViewModel.isPhonePositionedCorrectly && !appCoordinator.faceDetectionViewModel.isFaceDetected {
                    Text("Position your face in front of the camera.")
                        .font(.headline)
                        .padding()
                }
            }
            
            if appCoordinator.phonePositionViewModel.isPhonePositionedCorrectly && appCoordinator.faceDetectionViewModel.isFaceDetected {
                Text("Setup complete!")
                    .font(.title)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                if appCoordinator.isSetupStarted {
                    appCoordinator.stopSetup()
                } else {
                    appCoordinator.startSetup()
                }
            }) {
                if appCoordinator.isSetupStarted {
                    Text("Stop Setup")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Start Setup")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .bottom)
            
        }
        
    }
}

// MARK: - Previews

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

