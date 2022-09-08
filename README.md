# EasyFeedback

A utility widget that can be integrated into apps that require feedback from customers.

## Intro

- App uses Google Cloud Speech-To-Text Api to collect feedback data via user audio in real time. 
- The data collected is sent to backend([Github]()) where it is processed with GCP Natural Language Api and stored in database.
- Natural Language Api helps to retrieve useful information about speech data such as user likes/dislikes/rating.
- Businesses/Organisations can view feedbacks, provided by users, using web app([Github](https://github.com/DXTkastb/EasyFeedbackWeb)).


