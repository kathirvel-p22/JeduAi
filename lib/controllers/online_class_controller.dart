import 'package:get/get.dart';
import '../services/online_class_service.dart';
import '../models/online_class_model.dart';

class OnlineClassController extends GetxController {
  final OnlineClassService _classService = Get.find<OnlineClassService>();

  // Getters for reactive data
  List<OnlineClass> get allClasses => _classService.allClasses;
  List<OnlineClass> get upcomingClasses => _classService.upcomingClasses;
  List<OnlineClass> get liveClasses => _classService.liveClasses;
  List<ClassNotification> get notifications => _classService.notifications;
  int get unreadNotificationCount =>
      _classService.unreadNotificationCount.value;

  // Create a new class
  Future<OnlineClass?> createClass({
    required String title,
    required String subject,
    required String teacherName,
    required String teacherId,
    required DateTime scheduledTime,
    required int duration,
    required String meetingLink,
    required String description,
    required String classCode,
    int maxStudents = 50,
  }) async {
    try {
      final newClass = await _classService.createClass(
        title: title,
        subject: subject,
        teacherName: teacherName,
        teacherId: teacherId,
        scheduledTime: scheduledTime,
        duration: duration,
        meetingLink: meetingLink,
        description: description,
        classCode: classCode,
        maxStudents: maxStudents,
      );
      return newClass;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create class: ${e.toString()}');
      return null;
    }
  }

  // Join a class
  Future<bool> joinClass(String classId, String studentId) async {
    return await _classService.joinClass(classId, studentId);
  }

  // Leave a class
  Future<bool> leaveClass(String classId, String studentId) async {
    return await _classService.leaveClass(classId, studentId);
  }

  // Cancel a class
  Future<bool> cancelClass(String classId, String reason) async {
    return await _classService.cancelClass(classId, reason);
  }

  // Get student's enrolled classes
  List<OnlineClass> getStudentClasses(String studentId) {
    return _classService.getStudentClasses(studentId);
  }

  // Get teacher's classes
  List<OnlineClass> getTeacherClasses(String teacherId) {
    return _classService.getTeacherClasses(teacherId);
  }

  // Mark notification as read
  void markNotificationAsRead(String notificationId) {
    _classService.markNotificationAsRead(notificationId);
  }

  // Mark all notifications as read
  void markAllNotificationsAsRead() {
    _classService.markAllNotificationsAsRead();
  }

  // Get class by ID
  OnlineClass? getClassById(String classId) {
    try {
      return allClasses.firstWhere((c) => c.id == classId);
    } catch (e) {
      return null;
    }
  }

  // Check if student is enrolled in a class
  bool isStudentEnrolled(String classId, String studentId) {
    final classItem = getClassById(classId);
    return classItem?.enrolledStudents.contains(studentId) ?? false;
  }
}
