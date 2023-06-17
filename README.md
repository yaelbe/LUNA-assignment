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
