import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  Future<void> login(String email, String password, String role) async {
    isLoading.value = true;
    try {
      print('🔐 Attempting login for: $email with role: $role');

      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Firebase Auth successful for user: ${userCredential.user!.uid}');

      // Try to fetch user role from Firestore
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // If user document doesn't exist, use the selected role
          print(
            '⚠️ User document not found in Firestore. Using selected role: $role',
          );
          Get.snackbar(
            'Info',
            'User profile not found. Using selected role.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
          _navigateBasedOnRole(role);
          return;
        }

        // Get the role from Firestore
        String userRole = userDoc.get('role') ?? role;
        print('📋 Role from Firestore: $userRole');

        // Verify if the selected role matches the stored role
        if (userRole.toLowerCase() != role.toLowerCase()) {
          await _auth.signOut();
          Get.snackbar(
            'Error',
            'Invalid role selected. Your account is registered as $userRole.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
            duration: Duration(seconds: 3),
          );
          isLoading.value = false;
          return;
        }

        // Navigate based on verified role
        print('🚀 Navigating to dashboard for role: $userRole');
        _navigateBasedOnRole(userRole);
      } catch (firestoreError) {
        // If Firestore fails, still allow login with selected role
        print('⚠️ Firestore error: $firestoreError');
        print('📍 Proceeding with selected role: $role');
        Get.snackbar(
          'Info',
          'Could not verify role from database. Using selected role.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        _navigateBasedOnRole(role);
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      String errorMessage = 'An error occurred';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password.';
      } else {
        errorMessage = e.message ?? 'Authentication failed';
      }
      Get.snackbar(
        'Login Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      print('❌ Unexpected error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateBasedOnRole(String role) {
    print('🎯 Navigating based on role: $role');
    String normalizedRole = role.toLowerCase();

    if (normalizedRole == 'student') {
      print('➡️ Redirecting to: /student/dashboard');
      Get.offNamed('/student/dashboard');
    } else if (normalizedRole == 'staff') {
      print('➡️ Redirecting to: /staff/dashboard');
      Get.offNamed('/staff/dashboard');
    } else if (normalizedRole == 'admin') {
      print('➡️ Redirecting to: /admin/dashboard');
      Get.offNamed('/admin/dashboard');
    } else {
      print('❌ Invalid role: $role');
      Get.snackbar('Error', 'Invalid role: $role');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offNamed('/login');
  }
}
