# Notes Taking App with Firebase and Cloudinary Integration

This Flutter app allows users to securely create, read, update, and delete (CRUD) notes. Each user has their own authenticated account, ensuring that data remains private and separated for all users. The app leverages Firebase for authentication and database management, and Cloudinary for storing images.

---

## Features
- **User Authentication**: Secure login and signup functionality with Firebase.
- **Notes Management**: Add, view, edit, and delete notes.
  - Notes include a title, description, and an image.
- **Image Storage**: Images are uploaded to and retrieved from Cloudinary.
- **User-Specific Data**: Each user's notes are stored in a separate collection in Firebase, ensuring data privacy.
- **Responsive Design**: Optimized for Android devices.

---

## Prerequisites
1. Install Flutter SDK from the [official Flutter website](https://flutter.dev/docs/get-started/install).
2. Install Firebase CLI and set up Firebase for your project.
3. Create a Cloudinary account and configure an image upload preset.

---

## Setup Instructions

### 1. Clone the Repository
```` bash
git clone https://github.com/Mounish-T/Notehub
cd Notehub
````

### 2. Set Up Firebase
- Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/).
- Enable **Authentication** (Email/Password provider).
- Set up **Cloud Firestore**:
  1. Go to Firestore Database in Firebase Console.
  2. Click "Create Database."
  3. Set rules for user-based access.
- Download the \`google-services.json\` (for Android) files and place them in the respective folders:
  - \`android/app/\`

### 3. Set Up Cloudinary
- Sign up at [Cloudinary](https://cloudinary.com/).
- Go to the "Settings" and get your Cloud Name, API Key, and API Secret.
- Create an unsigned upload preset.
- Add the Cloudinary configuration to your app:
  - In your Flutter app, add the \`CLOUD_NAME\` and \`UPLOAD_PRESET\` in the code where Cloudinary is configured.

### 4. Install Dependencies
```` bash
flutter pub get
````

### 5. Run the App
- Use the following commands to run the app:
  ````bash
  flutter run
  ````
- Ensure an Android emulator/device is connected.

---

## Folder Structure
Will update soon....

---

## Dependencies Used
- **Firebase**:
  - \`firebase_core\`
  - \`firebase_auth\`
  - \`cloud_firestore\`
- **Cloudinary**:
  - \`cloudinary_sdk\`
  - \`http\`
- **Flutter Plugins**:
  - \`image_picker\`
  - \`path_provider\`
  - \`fluttertoast\`

---

## Security
- Each user's data is stored in a separate collection in Firestore.
- Firestore rules ensure users can only access their own data.
- Images uploaded to Cloudinary are tied to user-specific folders.

---

## Contribution
Feel free to fork the repository and submit pull requests. Contributions are welcome!

---

## Video Demonstration
https://drive.google.com/file/d/1eVt9FWYd8QGAYBY5OIw5OTRCGG-XfwNQ/view?usp=sharing


---

## Contact
For queries, contact:
- **Email**: tmounish02@gmail.com
- **GitHub**: https://github.com/Mounish-T
