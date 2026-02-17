# 🎓 JeduAI - Smart Learning & Assessment Platform

An AI-powered educational platform built with Flutter, featuring intelligent assessment generation, multi-language support, and real-time AI tutoring for VSB Engineering College.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![Gemini AI](https://img.shields.io/badge/Gemini-2.5--flash-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🌟 Features

### 🤖 AI-Powered Features
- **AI Assessment Generator**: Automatically creates quizzes with questions, options, and explanations using Gemini 2.5 Flash
- **AI Tutor**: Real-time conversational learning assistant with multi-language support
- **Smart Translation**: 100+ language support for all content (Admin, Staff, Student portals)
- **Video Translation**: Real-time video translation with AI-generated subtitles (20+ languages)
  - Malayalam ↔ English, Hindi ↔ Kannada, Tamil ↔ Hindi, etc.
  - Three modes: Basic, Advanced AI (Gemini), Full Pipeline (Whisper + NLLB)
  - Voice-over generation with Text-to-Speech
- **Intelligent Recommendations**: Personalized learning paths

### 👨‍🎓 Student Portal
- Dashboard with progress tracking
- AI-generated assessments (class-specific)
- Interactive learning modules
- Video player with controls and subtitles
- **Media Translation**: Upload videos/audio and translate to any language
- Content reader with translation
- Assessment history and scores
- Multi-language content translation (All UI elements)
- AI Tutor chat in any language

### 👨‍🏫 Staff Portal
- Assessment creation (manual & AI-generated)
- Student progress monitoring
- Class-based assessment management
- Real-time assessment preview
- Assessment analytics
- Export assessment data
- Multi-language interface support
- Translation tools for educational content

### 👨‍💼 Admin Portal
- Full platform oversight
- User management
- System analytics
- Platform configuration
- Multi-language admin interface
- Translation management

### 🎥 Video Translation Features
- **Upload & Translate**: Upload any video and translate to 20+ languages
- **Real-time Processing**: AI-powered transcription and translation
- **Subtitle Generation**: Automatic subtitle creation with timing
- **Voice-over**: Text-to-Speech in target language
- **Supported Languages**: English, Hindi, Tamil, Telugu, Kannada, Malayalam, Bengali, Marathi, Gujarati, Punjabi, Urdu, Spanish, French, German, Chinese, Japanese, Korean, Arabic, Portuguese, Russian

## 📥 Download APK

### Latest Release
Download the Android APK and install on your device:

**[📱 Download JeduAI APK (v1.0.0)](https://github.com/kathirvel-p22/JeduAi/releases/download/v1.0.0/jeduai-app-v1.0.0.apk)**

> **Note**: If the link doesn't work, go to [Releases](https://github.com/kathirvel-p22/JeduAi/releases) and download the latest APK.

### Installation Instructions
1. Download the APK file (160 MB)
2. On your Android device, go to Settings → Security
3. Enable "Install from Unknown Sources" or "Install Unknown Apps"
4. Open the downloaded APK file
5. Tap "Install" and wait for installation to complete
6. Launch JeduAI app
7. Login with demo credentials (see below)

### Build from Source
```bash
git clone https://github.com/kathirvel-p22/JeduAi.git
cd JeduAi/jeduai_app1
flutter pub get
flutter build apk --release
```
APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- A code editor (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/kathirvel-p22/JeduAi.git
cd JeduAi/jeduai_app1
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For web
flutter run -d chrome

# For mobile
flutter run
```

## 🔑 Demo Credentials

### Students
- **Email**: `kathirvel@gmail.com` | **Password**: Any password
- **Email**: `student@jeduai.com` | **Password**: Any password (Full access)

### Staff
- **Email**: `vijayakumar@vsb.edu` | **Password**: Any password
- **Email**: `shyamaladevi@vsb.edu` | **Password**: Any password
- **Email**: `balasubramani@vsb.edu` | **Password**: Any password
- **Email**: `arunjunaikarthick@vsb.edu` | **Password**: Any password
- **Email**: `manonmani@vsb.edu` | **Password**: Any password

### Admin
- **Email**: `admin@vsb.edu` | **Password**: Any password

## 📊 Platform Statistics

- **Total Users**: 8
- **Students**: 2
- **Staff**: 5
- **Admins**: 1
- **Departments**: Computer Science and Business Systems
- **Subjects**: 5 (Data Science, IoT, Big Data, Cloud Computing, Management)
- **AI Models**: Gemini 2.5 Flash
- **Languages Supported**: 100+

## 🏗️ Project Structure

```
jeduai_app1/
├── lib/
│   ├── config/              # Configuration files (API keys, etc.)
│   ├── controllers/         # State management controllers
│   ├── models/              # Data models
│   ├── routes/              # App routing
│   ├── services/            # Business logic & API services
│   │   ├── ai_assessment_generator_service.dart
│   │   ├── enhanced_ai_tutor_service.dart
│   │   ├── gemini_translation_service.dart
│   │   ├── shared_assessment_service.dart
│   │   └── user_data_service.dart
│   ├── views/               # UI screens
│   │   ├── auth/           # Login screens
│   │   ├── student/        # Student portal
│   │   ├── staff/          # Staff portal
│   │   └── common/         # Shared components
│   └── main.dart           # App entry point
├── assets/                  # Images, fonts, etc.
├── test/                    # Unit tests
├── web/                     # Web-specific files
└── pubspec.yaml            # Dependencies
```

## 🔧 Configuration

### Gemini API Setup
1. Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Update `lib/config/gemini_config.dart`:
```dart
static const String apiKey = 'YOUR_API_KEY_HERE';
```

### Firebase Setup (Optional)
1. Create a Firebase project
2. Update `lib/config/firebase_config.dart` with your credentials

### Supabase Setup (Optional)
1. Create a Supabase project
2. Update `lib/config/supabase_config.dart` with your credentials

## 📱 Supported Platforms

- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🎯 Key Technologies

- **Frontend**: Flutter & Dart
- **AI**: Google Gemini 2.5 Flash
- **Translation**: Gemini AI, Whisper STT, NLLB-200, Piper TTS
- **State Management**: GetX
- **Local Storage**: SharedPreferences
- **HTTP Client**: http package
- **UI Components**: Material Design 3
- **Video Processing**: video_player, flutter_tts

## 📚 Documentation

- [Platform Users & Features](PLATFORM_USERS_AND_FEATURES.md)
- [VSB College User System](VSB_COLLEGE_USER_SYSTEM.md)
- [AI Assessment Generator](AI_ASSESSMENT_GENERATOR_COMPLETE.md)
- [Shared Assessment System](SHARED_ASSESSMENT_SYSTEM.md)
- [Complete System Summary](COMPLETE_SYSTEM_SUMMARY.md)
- [Video Translation Guide](REAL_TIME_VIDEO_TRANSLATION_GUIDE.md)
- [Media Translation Feature](MEDIA_TRANSLATION_FEATURE.md)

## 🌐 Translation Features

### UI Translation (All Portals)
All user interfaces support 100+ languages:
- **Admin Portal**: Complete translation of all admin features
- **Staff Portal**: All staff tools and interfaces
- **Student Portal**: Full student experience in any language
- **AI Tutor**: Chat in your preferred language
- **Assessments**: Questions and answers in multiple languages

### Video/Audio Translation
Upload any video or audio file and translate:
1. **Upload**: Select video/audio file (MP4, AVI, MOV, MP3, WAV, etc.)
2. **Select Languages**: Choose source and target language
3. **Translation Mode**:
   - **Basic**: Quick translation with predefined content
   - **Advanced AI**: Real Gemini AI translation based on video content
   - **Full Pipeline**: Whisper STT → NLLB Translation → Piper TTS
4. **Output**: Translated video with subtitles and voice-over

### Supported Languages
English, Hindi, Tamil, Telugu, Kannada, Malayalam, Bengali, Marathi, Gujarati, Punjabi, Urdu, Spanish, French, German, Chinese, Japanese, Korean, Arabic, Portuguese, Russian, and 80+ more

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Kathirvel P**
- GitHub: [@kathirvel-p22](https://github.com/kathirvel-p22)

## 🙏 Acknowledgments

- VSB Engineering College
- Google Gemini AI Team
- Flutter Community
- All contributors and testers

## 📞 Support

For support, email kathirvel@gmail.com or create an issue in this repository.

---

**Made with ❤️ for VSB Engineering College - III CSBS**

---

## 📱 Download JeduAI App

### Android APK Download

**[⬇️ Click Here to Download JeduAI APK (v1.0.0)](https://drive.google.com/file/d/YOUR_FILE_ID/view?usp=sharing)**

**Size**: 160 MB | **Version**: 1.0.0 | **Platform**: Android 5.0+

> **Note**: Upload the APK to Google Drive and replace `YOUR_FILE_ID` with your actual file ID, or use one of the alternatives below.

### Alternative Download Options:
- **Build from Source**: Clone the repo and run `flutter build apk --release`
- **Contact**: Email kathirvel@gmail.com for APK file

### Quick Install Guide
1. Download the APK file above
2. Open Settings → Security → Enable "Install from Unknown Sources"
3. Open the downloaded APK file
4. Tap "Install"
5. Launch JeduAI and login with demo credentials

### Demo Login Credentials
- **Student**: `kathirvel@gmail.com` (any password)
- **Staff**: `vijayakumar@vsb.edu` (any password)
- **Admin**: `admin@vsb.edu` (any password)

### ✅ All Features Working
- ✅ AI Tutor (Multi-language chat)
- ✅ Text Translation (100+ languages)
- ✅ Video Translation (20+ languages)
- ✅ AI Assessment Generator
- ✅ All Portals (Admin, Staff, Student)

### Build Instructions
```bash
git clone https://github.com/kathirvel-p22/JeduAi.git
cd JeduAi/jeduai_app1
flutter pub get
flutter build apk --release
# APK will be at: build/app/outputs/flutter-apk/app-release.apk
```
