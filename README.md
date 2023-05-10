# Bimbeer - Tinder for Beer Lovers

## About the project

Bimbeer is a Flutter-based mobile application that is a clone of Tinder but with a twist - instead of swiping through user photos, users swipe through photos of beer. It's designed for beer lovers who are looking for someone to share a drink with.

## Technical Stack

The following technologies and libraries were used in the development of Bimbeer:

- Flutter SDK
- Firebase for authentication, database, and storage
- Bloc pattern for state management
- Equatable for value comparison
- Flutter Dotenv for environment variables
- Flutter Facebook Auth for Facebook authentication
- Flutter Geo Hash for location-based matching
- Flutter Launcher Icons for app icons
- Google Fonts for custom fonts
- Google Sign In for Google authentication
- Http for making HTTP requests
- Image Cropper for image cropping
- Image Picker for selecting images
- Numberpicker for selecting numerical values
- RxDart for reactive programming
- Step Progress Indicator for progress indication
- Swipe Cards for swiping functionality

## Functionalites

- authenticate with email and password
- authenticate with google
- edit profile informations
- edit discovery settings
- edit list of favorite beers
- edit profile avatar
- tinder-like profile swipe

## Missing functionalities

- real-time chat
- profile preview
- authenticate with facebook
- display pairs
- delete pairs

## Running the App Locally

To run the app locally, follow these steps:

Clone the repository: 
```sh
git clone https://github.com/bimbeer/mobile.git
```
Navigate to the project directory: 
```sh
cd <project-location>
```
Install dependencies: 
```sh
flutter pub get
```
Run the app: 
```sh
flutter run
```

## Building and Installing the App

To build the app and install it on a device, follow these steps:

Make sure you have a Flutter SDK installed and configured on your machine.
Clone the repository: 
```sh
git clone clone https://github.com/bimbeer/mobile.git
```
Navigate to the project directory: 
```sh
`cd <project-location>`
```
Run flutter build apk to build an APK file.
```sh
flutter build
```
Run flutter install to install the app on a connected device.
```sh
flutter install
```
For more information on building and deploying Flutter apps, refer to the [official documentation](https://flutter.dev/docs/deployment).