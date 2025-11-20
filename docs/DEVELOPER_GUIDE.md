# JeduAI Developer Guide

## Overview

This guide is for developers who want to contribute to or extend the JeduAI platform.

## Table of Contents

1. [Development Setup](#development-setup)
2. [Project Architecture](#project-architecture)
3. [Code Standards](#code-standards)
4. [Adding Features](#adding-features)
5. [Testing](#testing)
6. [Debugging](#debugging)
7. [Performance Optimization](#performance-optimization)
8. [Contributing](#contributing)

---

## Development Setup

### Prerequisites

```bash
# Check Flutter installation
flutter doctor

# Required versions
Flutter: >=3.0.0
Dart: >=3.0.0
```

### Clone and Setup

```bash
# Clone repository
git clone https://github.com/your-org/jeduai-app.git
cd jeduai-app/jeduai_app1

# Install dependencies
flutter pub get

# Run code generation (if needed)
flutter pub run build_runner build

# Run the app
flutter run
```

### IDE Setup

**VS Code Extensions:**
- Flutter
- Dart
- Error Lens
- GitLens
- Better Comments

**Android Studio Plugins:**
- Flutter
- Dart
- Rainbow Brackets
- Key Promoter X

### Environment Configuration

```dart
// lib/config/environment.dart
class Environment {
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  
  static String get supabaseUrl {
    switch (env) {
      case 'prod':
        return 'https://prod.supabase.co';
      case 'staging':
        return 'https://staging.supabase.co';
      default:
        return 'https://dev.supabase.co';
    }
  }
}
```

---

## Project Architecture

### Folder Structure

```
lib/
├── config/              # Configuration files
│   ├── supabase_config.dart
│   └── environment.dart
├── controllers/         # GetX controllers (business logic)
│   ├── auth_controller.dart
│   ├── online_class_controller.dart
│   └── translation_controller.dart
├── models/             # Data models
│   ├── user_model.dart
│   ├── online_class_model.dart
│   └── assessment_model.dart
├── services/           # Business logic services
│   ├── database_service.dart
│   ├── user_service.dart
│   ├── notification_service.dart
│   └── video_conference_service.dart
├── views/              # UI screens
│   ├── admin/          # Admin portal views
│   ├── staff/          # Staff portal views
│   ├── student/        # Student portal views
│   └── common/         # Shared views
├── widgets/            # Reusable widgets
│   ├── custom_button.dart
│   └── loading_indicator.dart
├── routes/             # Navigation
│   └── app_routes.dart
├── theme/              # Theming
│   └── app_theme.dart
├── utils/              # Utility functions
│   ├── constants.dart
│   └── helpers.dart
└── main.dart           # Entry point
```

### Architecture Pattern

**GetX Pattern (MVC):**

```
View (UI) ↔ Controller (Logic) ↔ Service (Data)
```

**Example Flow:**

```dart
// 1. View
class StudentDashboard extends StatelessWidget {
  final controller = Get.find<StudentController>();
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.userName.value));
  }
}

// 2. Controller
class StudentController extends GetxController {
  final userService = Get.find<UserService>();
  final userName = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }
  
  void loadUserData() {
    final user = userService.currentUser;
    userName.value = user?.name ?? '';
  }
}

// 3. Service
class UserService extends GetxService {
  final _currentUser = Rxn<User>();
  User? get currentUser => _currentUser.value;
  
  Future<void> login(String email, String password) async {
    final user = await DatabaseService().authenticateUser(email, password);
    _currentUser.value = user;
  }
}
```

### State Management

**GetX Reactive Programming:**

```dart
// Observable variable
final count = 0.obs;

// Update
count.value++;

// Listen
Obx(() => Text('Count: ${count.value}'));

// Or use GetBuilder
GetBuilder<MyController>(
  builder: (controller) => Text(controller.data),
);
```

### Dependency Injection

```dart
// Register services
void main() {
  // Permanent services
  Get.put(DatabaseService(), permanent: true);
  Get.put(UserService(), permanent: true);
  
  // Lazy services
  Get.lazyPut(() => NotificationService());
  
  runApp(MyApp());
}

// Use anywhere
final userService = Get.find<UserService>();
```

---

## Code Standards

### Naming Conventions

```dart
// Classes: PascalCase
class UserService {}
class OnlineClassController {}

// Variables: camelCase
String userName;
int studentCount;

// Constants: UPPER_SNAKE_CASE
const String API_KEY = 'key';
const int MAX_STUDENTS = 50;

// Private: _prefix
String _privateVariable;
void _privateMethod() {}

// Files: snake_case
user_service.dart
online_class_controller.dart
```

### Code Organization

```dart
// 1. Imports (grouped)
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

// 2. Class definition
class MyWidget extends StatelessWidget {
  // 3. Constants
  static const String title = 'My Widget';
  
  // 4. Properties
  final String name;
  final int age;
  
  // 5. Constructor
  const MyWidget({
    Key? key,
    required this.name,
    required this.age,
  }) : super(key: key);
  
  // 6. Lifecycle methods
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 7. Public methods
  void publicMethod() {}
  
  // 8. Private methods
  void _privateMethod() {}
}
```

### Documentation

```dart
/// Service for managing user authentication and profiles.
///
/// This service handles:
/// - User login/logout
/// - Profile management
/// - Session management
///
/// Example:
/// ```dart
/// final userService = Get.find<UserService>();
/// await userService.login('email@example.com', 'password');
/// ```
class UserService extends GetxService {
  /// Current authenticated user.
  User? get currentUser => _currentUser.value;
  
  /// Authenticates user with email and password.
  ///
  /// Returns [User] if successful, null otherwise.
  /// Throws [AuthException] if credentials are invalid.
  Future<User?> login(String email, String password) async {
    // Implementation
  }
}
```

### Error Handling

```dart
// Use try-catch for async operations
Future<void> loadData() async {
  try {
    final data = await DatabaseService().getData();
    // Process data
  } on NetworkException catch (e) {
    // Handle network errors
    Get.snackbar('Error', 'Network error: ${e.message}');
  } on DatabaseException catch (e) {
    // Handle database errors
    Get.snackbar('Error', 'Database error: ${e.message}');
  } catch (e) {
    // Handle unexpected errors
    Get.snackbar('Error', 'Unexpected error: $e');
    print('Error in loadData: $e');
  }
}

// Custom exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}
```

---

## Adding Features

### Step-by-Step Guide

#### 1. Create Model

```dart
// lib/models/course_model.dart
class Course {
  final String id;
  final String name;
  final String description;
  final String teacherId;
  final List<String> studentIds;
  
  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherId,
    required this.studentIds,
  });
  
  // From JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      teacherId: json['teacher_id'],
      studentIds: List<String>.from(json['student_ids'] ?? []),
    );
  }
  
  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'teacher_id': teacherId,
      'student_ids': studentIds,
    };
  }
}
```

#### 2. Create Service

```dart
// lib/services/course_service.dart
class CourseService extends GetxService {
  final _courses = <Course>[].obs;
  List<Course> get courses => _courses;
  
  /// Load all courses
  Future<void> loadCourses() async {
    try {
      final response = await DatabaseService().getCourses();
      _courses.value = response.map((json) => Course.fromJson(json)).toList();
    } catch (e) {
      print('Error loading courses: $e');
      rethrow;
    }
  }
  
  /// Create new course
  Future<String> createCourse(Course course) async {
    try {
      final courseId = await DatabaseService().createCourse(course.toJson());
      await loadCourses(); // Refresh list
      return courseId;
    } catch (e) {
      print('Error creating course: $e');
      rethrow;
    }
  }
  
  /// Get course by ID
  Course? getCourseById(String id) {
    return _courses.firstWhereOrNull((course) => course.id == id);
  }
}
```

#### 3. Create Controller

```dart
// lib/controllers/course_controller.dart
class CourseController extends GetxController {
  final courseService = Get.find<CourseService>();
  
  final isLoading = false.obs;
  final selectedCourse = Rxn<Course>();
  
  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }
  
  Future<void> loadCourses() async {
    isLoading.value = true;
    try {
      await courseService.loadCourses();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load courses');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> createCourse(String name, String description) async {
    isLoading.value = true;
    try {
      final course = Course(
        id: '',
        name: name,
        description: description,
        teacherId: Get.find<UserService>().currentUser!.id,
        studentIds: [],
      );
      
      await courseService.createCourse(course);
      Get.back();
      Get.snackbar('Success', 'Course created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create course');
    } finally {
      isLoading.value = false;
    }
  }
  
  void selectCourse(Course course) {
    selectedCourse.value = course;
  }
}
```

#### 4. Create View

```dart
// lib/views/staff/courses_view.dart
class CoursesView extends StatelessWidget {
  final controller = Get.put(CourseController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Get.to(() => CreateCourseView()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        final courses = controller.courseService.courses;
        
        if (courses.isEmpty) {
          return Center(child: Text('No courses yet'));
        }
        
        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(course: course);
          },
        );
      }),
    );
  }
}

// lib/views/staff/create_course_view.dart
class CreateCourseView extends StatelessWidget {
  final controller = Get.find<CourseController>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Course')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Course Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.createCourse(
                        nameController.text,
                        descriptionController.text,
                      ),
              child: controller.isLoading.value
                  ? CircularProgressIndicator()
                  : Text('Create Course'),
            )),
          ],
        ),
      ),
    );
  }
}
```

#### 5. Add Database Methods

```dart
// lib/services/database_service.dart
class DatabaseService extends GetxService {
  // ... existing code ...
  
  /// Get all courses
  Future<List<Map<String, dynamic>>> getCourses() async {
    try {
      final response = await _client
          .from('courses')
          .select()
          .order('created_at', ascending: false);
      return response;
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }
  
  /// Create new course
  Future<String> createCourse(Map<String, dynamic> courseData) async {
    try {
      final courseId = _uuid.v4();
      await _client.from('courses').insert({
        'id': courseId,
        ...courseData,
        'created_at': DateTime.now().toIso8601String(),
      });
      return courseId;
    } catch (e) {
      print('Error creating course: $e');
      throw Exception('Failed to create course');
    }
  }
}
```

#### 6. Add Routes

```dart
// lib/routes/app_routes.dart
class AppRoutes {
  // ... existing routes ...
  static const courses = '/courses';
  static const createCourse = '/create-course';
}

// Add to GetMaterialApp
GetMaterialApp(
  getPages: [
    // ... existing pages ...
    GetPage(name: AppRoutes.courses, page: () => CoursesView()),
    GetPage(name: AppRoutes.createCourse, page: () => CreateCourseView()),
  ],
);
```

---

## Testing

### Unit Tests

```dart
// test/services/course_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jeduai_app1/services/course_service.dart';

void main() {
  late CourseService courseService;
  
  setUp(() {
    courseService = CourseService();
  });
  
  tearDown(() {
    Get.reset();
  });
  
  group('CourseService', () {
    test('should load courses', () async {
      await courseService.loadCourses();
      expect(courseService.courses, isNotEmpty);
    });
    
    test('should create course', () async {
      final course = Course(
        id: '',
        name: 'Test Course',
        description: 'Test Description',
        teacherId: 'STF001',
        studentIds: [],
      );
      
      final courseId = await courseService.createCourse(course);
      expect(courseId, isNotEmpty);
    });
    
    test('should get course by ID', () {
      final course = courseService.getCourseById('COURSE001');
      expect(course, isNotNull);
      expect(course?.id, equals('COURSE001'));
    });
  });
}
```

### Widget Tests

```dart
// test/widgets/course_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeduai_app1/widgets/course_card.dart';

void main() {
  testWidgets('CourseCard displays course information', (tester) async {
    final course = Course(
      id: '1',
      name: 'Test Course',
      description: 'Test Description',
      teacherId: 'STF001',
      studentIds: [],
    );
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CourseCard(course: course),
        ),
      ),
    );
    
    expect(find.text('Test Course'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });
}
```

### Integration Tests

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jeduai_app1/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('end-to-end test', () {
    testWidgets('complete user flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Login
      await tester.enterText(find.byKey(Key('email')), 'test@example.com');
      await tester.enterText(find.byKey(Key('password')), 'password');
      await tester.tap(find.byKey(Key('login')));
      await tester.pumpAndSettle();
      
      // Navigate to courses
      await tester.tap(find.text('Courses'));
      await tester.pumpAndSettle();
      
      // Verify courses loaded
      expect(find.byType(CourseCard), findsWidgets);
    });
  });
}
```

### Run Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/course_service_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run integration tests
flutter test integration_test/app_test.dart
```

---

## Debugging

### Debug Tools

```dart
// Enable debug logging
void main() {
  if (kDebugMode) {
    print('Running in debug mode');
  }
  runApp(MyApp());
}

// Log network requests
class LoggingInterceptor {
  void logRequest(String url, Map<String, dynamic> data) {
    print('Request: $url');
    print('Data: $data');
  }
  
  void logResponse(String url, dynamic response) {
    print('Response from $url: $response');
  }
}
```

### Flutter DevTools

```bash
# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Or run with app
flutter run --observatory-port=9200
```

### Common Issues

**GetX Controller Not Found:**
```dart
// Solution: Register controller before use
Get.put(MyController());
final controller = Get.find<MyController>();
```

**State Not Updating:**
```dart
// Solution: Use .obs and Obx
final count = 0.obs; // Observable
Obx(() => Text('${count.value}')); // Observer
```

**Memory Leaks:**
```dart
// Solution: Dispose controllers
@override
void onClose() {
  textController.dispose();
  subscription.cancel();
  super.onClose();
}
```

---

## Performance Optimization

### Best Practices

```dart
// 1. Use const constructors
const Text('Hello'); // Better than Text('Hello')

// 2. Avoid rebuilding entire tree
Obx(() => Text(controller.data.value)); // Only rebuilds Text

// 3. Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
);

// 4. Cache network images
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
);

// 5. Lazy load data
Get.lazyPut(() => HeavyService());

// 6. Debounce user input
final debouncer = Debouncer(milliseconds: 500);
debouncer.run(() => search(query));
```

### Profiling

```bash
# Profile app performance
flutter run --profile

# Analyze build times
flutter build apk --analyze-size

# Check for jank
flutter run --trace-skia
```

---

## Contributing

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push to remote
git push origin feature/new-feature

# Create pull request on GitHub
```

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

**Examples:**
```
feat(courses): add course creation feature

- Add CourseService
- Add CourseController
- Add CoursesView
- Add database methods

Closes #123
```

### Pull Request Checklist

- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No console errors
- [ ] Tested on multiple devices
- [ ] Performance impact considered
- [ ] Security implications reviewed

---

## Resources

### Documentation
- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [GetX Docs](https://github.com/jonataslaw/getx)
- [Supabase Docs](https://supabase.com/docs)

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/FlutterDev](https://reddit.com/r/FlutterDev)

---

**Last Updated**: December 2024
