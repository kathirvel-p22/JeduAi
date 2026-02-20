import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'config/supabase_config.dart';
import 'services/database_service.dart';
import 'services/user_service.dart';
import 'services/notification_service.dart';
import 'services/online_class_service.dart';
import 'services/gemini_translation_service.dart';
import 'controllers/online_class_controller.dart';
import 'services/enhanced_translation_service.dart';
import 'services/enhanced_ai_tutor_service.dart';
import 'services/shared_assessment_service.dart';
import 'services/media_translation_service.dart';
import 'services/user_session_service.dart';
import 'services/local_auth_service.dart';
import 'controllers/auth_controller.dart';
import 'services/app_update_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  try {
    await SupabaseConfig.initialize();
    print('✅ Supabase initialized successfully');
  } catch (e) {
    print('⚠️ Supabase initialization failed: $e');
    print('⚠️ App will run with mock data');
  }

  // Try to initialize Firebase, but continue if it fails
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('⚠️ Firebase initialization failed: $e');
    print('⚠️ App will run without Firebase authentication');
  }

  // Initialize core services
  Get.put(UserService(), permanent: true);
  Get.put(NotificationService(), permanent: true);
  Get.put(OnlineClassService(), permanent: true);
  Get.put(DatabaseService(), permanent: true);

  // Initialize authentication services
  Get.put(LocalAuthService(), permanent: true);
  Get.put(UserSessionService(), permanent: true);
  Get.put(AuthController(), permanent: true);
  print('✅ Authentication services initialized');

  // Initialize controllers
  Get.put(OnlineClassController(), permanent: true);
  print('✅ Online Class Controller initialized');

  // Initialize translation services
  Get.put(GeminiTranslationService(), permanent: true);
  Get.put(EnhancedTranslationService(), permanent: true);
  print('✅ Translation services initialized');

  // Initialize AI Tutor service
  Get.put(EnhancedAITutorService(), permanent: true);
  print('✅ AI Tutor service initialized');

  // Initialize Shared Assessment Service
  Get.put(SharedAssessmentService(), permanent: true);
  print('✅ Shared Assessment Service initialized');

  // Initialize Media Translation Service
  Get.put(MediaTranslationService(), permanent: true);
  print('✅ Media Translation Service initialized');

  // Initialize Package Info for version checking
  final packageInfo = await PackageInfo.fromPlatform();
  Get.put(packageInfo, permanent: true);
  print('✅ Package Info initialized (v${packageInfo.version})');

  // Initialize App Update Service
  Get.put(AppUpdateService(), permanent: true);
  print('✅ App Update Service initialized');

  // Initialize database with automatic cleanup
  try {
    await Get.find<DatabaseService>().initializeDatabase();
    print('✅ Database initialized with automatic cleanup enabled');
  } catch (e) {
    print('⚠️ Database initialization warning: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Check for updates 2 seconds after app starts
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.isRegistered<AppUpdateService>()) {
        Get.find<AppUpdateService>().checkForUpdates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JeduAI - Smart Learning & Language Empowerment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(elevation: 0, centerTitle: false),
      ),
      initialRoute: '/login',
      getPages: AppRoutes.routes,
    );
  }
}
