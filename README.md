# 🌾 KishanSahayak – Empowering Farmers with AI

KishanSahayak is an AI-powered, multilingual mobile application designed to support small and marginal farmers by offering personalized agricultural assistance, smart reminders, crop health diagnostics, and a built-in agri-marketplace — all in one unified platform.

## 🚀 Key Features

- 📆 **Smart Scheduling & Reminders** – Timely, app-based alerts for field tasks like irrigation, fertilization, and pest control.
- 🦠 **Crop Disease Detection** – Instant plant disease diagnosis using smartphone images and TensorFlow Lite (on-device AI).
- 🌐 **Multilingual Support** – Full app access in multiple Indian languages for better regional inclusivity.
- 🌱 **Location-Based Crop Suggestions** – Recommends crops based on local soil and climate conditions.
- 🤖 **AI Chatbot Assistant** – Gemini API-powered conversational support for farming queries.
- 📷 **Field Scanning** – Smartphone camera-based scanning for real-time analysis of soil, crop, and atmosphere.
- 🛒 **Integrated Marketplace** – Purchase seeds, fertilizers, tools, and sell crops directly through the app.
- 🔄 **Latest Updates Section** – In-app news on farming trends, government schemes, and seasonal alerts.
- 🔐 **Google Authentication** – Secure and simplified login via Google sign-in.

## 🧰 Tech Stack

### 🔑 Google Cloud & APIs
- **Firebase Authentication** (Email/Password, Google Sign-in)
- **Cloud Firestore** (Real-time DB)
- **Firebase Storage** (Image & file storage)
- **Gemini API** (AI-powered plant care advisory)

### 🤖 AI/ML Stack
- **TensorFlow Lite** – On-device inference for plant disease detection
- **Image Processing** – Custom image classification and scanning

### 📱 Frontend
- **Flutter Framework**
- **Material Design**
- **Dart Language**

### 🛠 Development Tools
- **Android Studio**
- **Git Version Control**

### 📦 Core Dependencies
```yaml
firebase_core: ^2.24.0  
firebase_auth: ^4.15.0  
cloud_firestore: ^4.13.0  
firebase_storage: ^11.5.0  
tflite_flutter: ^0.11.0  
image_picker: ^1.0.4  
image: ^3.0.1
