# EasyFeedback

A utility widget that can be integrated into apps that require feedback from customers.

## Intro

- App uses Google Cloud Speech-To-Text Api to collect feedback data via user audio in real time.
- The data collected is sent to backend(Spring App, MYSQL database [[github]](https://github.com/DXTkastb/EasyFeedbackBackend)) where it is processed with GCP Natural Language Api and stored in database.
- Natural Language Api helps to retrieve useful information about speech data such as user likes/dislikes/rating.
- Businesses/Organisations can view feedbacks, provided by users, using web app(Flutter Web App [[github]](https://github.com/DXTkastb/EasyFeedbackWeb)).

## Installation

- Download this repository
- Generate Google Cloud Service Key ([GCP guide](https://cloud.google.com/iam/docs/creating-managing-service-account-keys))
- Copy the content of service-key.json into cred.json (repository/asset/ folder)
- open cmd/terminal :
- 'flutter run' to test app in emulator/physical device
- 'flutter build apk' to build apk. Generated apk can be installed on android device.

### Screenshots
