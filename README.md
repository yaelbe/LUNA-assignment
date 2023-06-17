# LUNA-assignment

The goal of this assignment is to create an interactive setup guide for our
cool refraction exam app! 🤓
To obtain accurate results, the user must position his phone vertically in a
stable position and place his face in front of the front camera.
The setup guide will instruct the user to apply the two conditions described
above.
You are required to build an iOS application using Swift that will contain the
interactive refraction exam setup guide.
There are two instructions in the guide:
1. First instruction : Position the phone at the correct angle.
The instruction is displayed to the user until the device is positioned at the
required angle for 3 seconds. The required angle is 70 to 110 degrees.
After completing this condition, the next button that activates the next
instruction is enabled.
2. Second instruction : Position your face in front of the camera
The instruction is displayed to the user until a face detection is received.
After completing this condition, the next button that starts the test is
enabled. While waiting for face detection, if the user moves the device and
it is not at the required angle, the first instruction should appear again.

## what is inside?
This code is written in Swift and uses the SwiftUI framework. It consists of several classes and structs that work together to create a setup guide app for a refraction exam. Here is a code review of the provided code:

AppCoordinator: This class is responsible for coordinating the setup process. It manages the state of whether the setup has started or not (isSetupStarted) and contains instances of PhonePositionViewModel and FaceDetectionViewModel.

PhonePositionViewModel: This class handles the phone position check using the device's motion data. It tracks the current angle of the device (currentAngle) and whether the phone is positioned correctly (isPhonePositionedCorrectly). It starts device motion updates and updates the state based on the pitch angle of the device.

FaceDetectionViewModel: This class handles face detection using the device's camera. It uses AVCaptureSession to capture video frames and performs face detection using the Vision framework. It updates the state based on whether a face is detected (isFaceDetected).

ContentView: This SwiftUI view is the main user interface of the app. It displays instructions and feedback based on the setup process and provides a button to start/stop the setup. It also observes the state changes in AppCoordinator and the view models to update the UI.

Overall, the code looks well-structured and follows the MVVM (Model-View-ViewModel) architectural pattern. The use of Combine framework publishers (@Published, sink, AnyCancellable) allows for reactive updates of the UI based on state changes. The code handles camera permissions, motion updates, and face detection appropriately.
