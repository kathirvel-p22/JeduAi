# 🎓 JeduAI - Smart Learning & Assessment Platform

An AI-powered educational platform built with Flutter, featuring intelligent assessment generation, multi-language support, and real-time AI tutoring for VSB Engineering College.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![Gemini AI](https://img.shields.io/badge/Gemini-2.5--flash-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🌟 Features

### 🤖 AI-Powered Features
- **AI Assessment Generator**: Automatically creates quizzes with questions, options, and explanations using Gemini 2.5 Flash
- **AI Tutor**: Real-time conversational learning assistant
- **Smart Translation**: 100+ language support for all content
- **Intelligent Recommendations**: Personalized learning paths

### 👨‍🎓 Student Portal
- Dashboard with progress tracking
- AI-generated assessments (class-specific)
- Interactive learning modules
- Video player with controls
- Content reader
- Assessment history and scores
- Multi-language content translation

### 👨‍🏫 Staff Portal
- Assessment creation (manual & AI-generated)
- Student progress monitoring
- Class-based assessment management
- Real-time assessment preview
- Assessment analytics
- Export assessment data

### 👨‍💼 Admin Portal
- Full platform oversight
- User management
- System analytics
- Platform configuration

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
- **State Management**: GetX
- **Local Storage**: SharedPreferences
- **HTTP Client**: http package
- **UI Components**: Material Design 3

## 📚 Documentation

- [Platform Users & Features](PLATFORM_USERS_AND_FEATURES.md)
- [VSB College User System](VSB_COLLEGE_USER_SYSTEM.md)
- [AI Assessment Generator](AI_ASSESSMENT_GENERATOR_COMPLETE.md)
- [Shared Assessment System](SHARED_ASSESSMENT_SYSTEM.md)
- [Complete System Summary](COMPLETE_SYSTEM_SUMMARY.md)

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
