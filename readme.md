## This theos project is still under development.

### What is this ?

This is a simple project to push notifications to your iOS device without using Apple Push Notification Service (APNS)

However it does not work, uploaded here so that everyone can contribute to this project.

The error

`wsnotify An error occurred: NSInvalidArgumentException, -[SpringBoard setSession:]: unrecognized selector sent to instance 0x10303da00`

From the error message, it seems that the SpringBoard does not have the method `setSession:`

idk why it needs it

you can change ws address in the source code and build with `make clean package`

lastly i am neither an iOS developer nor a tweak developer
