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
<img src="https://github.com/DXTkastb/EasyFeedback/assets/38028330/0af13ea7-c5cd-4690-8f16-9a65eb7f4742" width="410" height="800">
<img src="https://github.com/DXTkastb/EasyFeedback/assets/38028330/bab7d350-b602-4839-832b-36d77b776fef" width="410" height="800">
<img src="https://github.com/DXTkastb/EasyFeedback/assets/38028330/1b4cf624-98e6-4c5b-9339-7a7ae0842351" width="410" height="800">
<img src="https://github.com/DXTkastb/EasyFeedback/assets/38028330/792e6e3a-66f9-4778-b0e7-b964608a8b66" width="410" height="800">
<img src="https://github.com/DXTkastb/EasyFeedback/assets/38028330/e62be302-ba3d-47b1-8fd7-0edc90848fdd" width="410" height="800">
<img src="https://github.com/DXTkastb/EasyFeedback/assets/38028330/4f4af042-a1b4-48a4-b10c-093eb6bace75" width="410" height="800">


Processed data from the feedback(in the above screenshot) can be viewed here: [Web App](https://github.com/DXTkastb/EasyFeedbackWeb#screenshots)
