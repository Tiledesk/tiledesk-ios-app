# README #

# Features #

<img src="https://user-images.githubusercontent.com/32564846/34433123-4873eca4-ec7d-11e7-8a80-4ad54def8653.png" width="250">  <img src="https://user-images.githubusercontent.com/32564846/34433130-5a797022-ec7d-11e7-94c0-cd91cb7a7e3b.png" width="250"> <img src="https://user-images.githubusercontent.com/32564846/34433695-39e04468-ec81-11e7-84a3-920e9098a2a1.png" width="250">


Chat21 is a *multiplatform chat SDK* developed using only Firebase as the backend.

This demo shows the following features:

* Tab based chat application
* Recent conversations' list
* Direct message (one to one message)
* Offline messages' history
* Received receipts (you can see if a message was sent and delivered)
* Presence Manager with online/offline and inactivity period indicator
* Integration of a custom user profile's view
* Signup/Login with email and password
* Synchronized contacts (with offline search and selection)
* Integrates an example of a mobile live-chat support (an "help" button on the top left corner of every tab)

# Build & run #

Before you do anything else, you shoud change the Bundle Identifier, and assign an appropriate Team.

Select **chat21** in the **Project Navigator**, and then select the **chat21** target. In the **General tab** change **Bundle Identifier** to use your own domain name, in reverse-domain-notation - for example **it.mycompany.mychat**.
Then, from the **Team** menu, select the team associated with your developer account like so:

<img width="1103" alt="xcode-conf" src="https://user-images.githubusercontent.com/32564846/36319768-44454388-1344-11e8-9033-c2290fa018fa.png">


1. Create a new project on [firebase](https://firebase.google.com) site
2. Select the option **Add Firebase to your iOS app**
3. Configure you Xcode project copying your Google-Info.plist (download the file from the Firebase iOS App dashboard).
5. Run "pod install" in the Xcode project folder.
6. Install the Firebase cloud functions available [here](https://github.com/chat21/chat21-cloud-functions). Follow the included instructions. This will setup your backend.

Now open Xcode project using the new file "chat21.xcworkspace"

## Download & install Chat21 libs

Download **Chat21Core** & **Chat21UI** folders from [here](https://github.com/chat21/chat21-ios-sdk).

<img width="629" alt="screenshot github-folders" src="https://user-images.githubusercontent.com/32564846/40603704-066f33f8-625d-11e8-9114-700d081f4f68.png">

Drag & drop the two folders in your Xcode project:

<img width="1136" alt="screenshot dragdroplibs" src="https://user-images.githubusercontent.com/32564846/40605514-ec150cde-6262-11e8-8ab3-c00214f4ab7c.png">

Verify that the target is correctly set to "chat21":

<img width="1144" alt="screenshot verify-target" src="https://user-images.githubusercontent.com/32564846/40603760-351ae94a-625d-11e8-88a3-dd8b88c4119e.png">

Setup finished. Now you can **build & run** the project!

Enjoy!

If you need support please open a GitHub issue.
