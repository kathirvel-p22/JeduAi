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

      String uid = userCredential.user!.uid;
      String normalizedRole = role.toLowerCase();

      // Try to fetch user from role-specific collection first
      DocumentSnapshot? roleDoc;
      try {
        if (normalizedRole == 'student') {
          roleDoc = await _firestore.collection('students').doc(uid).get();
        } else if (normalizedRole == 'staff') {
          roleDoc = await _firestore.collection('staff').doc(uid).get();
        } else if (normalizedRole == 'admin') {
          roleDoc = await _firestore.collection('admins').doc(uid).get();
        }

        if (roleDoc != null && roleDoc.exists) {
          String userRole = roleDoc.get('role') ?? role;
          print('📋 Role from ${normalizedRole}s collection: $userRole');

          // Verify role matches
          if (userRole.toLowerCase() != normalizedRole) {
            await _auth.signOut();
            Get.snackbar(
              'Error',
              'Invalid role selected. Your account is registered as $userRole.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Get.theme.colorScheme.error.withAlpha(26),
              duration: Duration(seconds: 3),
            );
            isLoading.value = false;
            return;
          }

          // Update last login for admins
          if (normalizedRole == 'admin') {
            await _firestore.collection('admins').doc(uid).update({
              'lastLogin': FieldValue.serverTimestamp(),
            });
          }

          print('🚀 Navigating to dashboard for role: $userRole');
          _navigateBasedOnRole(userRole);
          return;
        }
      } catch (e) {
        print('⚠️ Role-specific collection error: $e');
      }

      // Fallback: Try main users collection
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(uid)
            .get();

        if (!userDoc.exists) {
          print('⚠️ User document not found. Using selected role: $role');
          Get.snackbar(
            'Info',
            'User profile not found. Using selected role.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
          _navigateBasedOnRole(role);
          return;
        }

        String userRole = userDoc.get('role') ?? role;
        print('📋 Role from users collection: $userRole');

        if (userRole.toLowerCase() != normalizedRole) {
          await _auth.signOut();
          Get.snackbar(
            'Error',
            'Invalid role selected. Your account is registered as $userRole.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error.withAlpha(26),
            duration: Duration(seconds: 3),
          );
          isLoading.value = false;
          return;
        }

        _navigateBasedOnRole(userRole);
      } catch (firestoreError) {
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
        backgroundColor: Get.theme.colorScheme.error.withAlpha(26),
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      print('❌ Unexpected error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withAlpha(26),
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

  /// Sign up with email and password
  Future<bool> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    isLoading.value = true;
    try {
      print('📝 Creating account for: $email with role: $role');

      // Create user with Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Firebase Auth account created: ${userCredential.user!.uid}');

      // Update display name
      await userCredential.user!.updateDisplayName(name);

      String uid = userCredential.user!.uid;
      Map<String, dynamic> userData = {
        'uid': uid,
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Create user document in main users collection
      await _firestore.collection('users').doc(uid).set(userData);
      print('✅ User document created in users collection');

      // Create role-specific document in separate collections
      if (role == 'student') {
        await _firestore.collection('students').doc(uid).set({
          ...userData,
          'enrolledCourses': [],
          'completedAssessments': [],
          'totalScore': 0,
          'averageScore': 0.0,
          'department': '',
          'year': '',
          'section': '',
        });
        print('✅ Student profile created in students collection');
      } else if (role == 'staff') {
        await _firestore.collection('staff').doc(uid).set({
          ...userData,
          'department': '',
          'designation': '',
          'subjects': [],
          'classesAssigned': [],
          'totalStudents': 0,
        });
        print('✅ Staff profile created in staff collection');
      } else if (role == 'admin') {
        await _firestore.collection('admins').doc(uid).set({
          ...userData,
          'permissions': ['all'],
          'managedDepartments': [],
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print('✅ Admin profile created in admins collection');
      }

      print('🎉 Account creation successful!');
      return true;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      String errorMessage = 'An error occurred';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for this email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      } else {
        errorMessage = e.message ?? 'Signup failed';
      }
      Get.snackbar(
        'Signup Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withAlpha(51),
        duration: Duration(seconds: 3),
      );
      return false;
    } catch (e) {
      print('❌ Unexpected error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withAlpha(51),
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
