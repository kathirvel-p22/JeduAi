import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../services/user_data_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'Student';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie animation placeholder
                  // Lottie.asset('assets/lottie/login_animation.json', height: 150),
                  Icon(Icons.school, size: 100, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'JeduAI Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(204),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedRole,
                      dropdownColor: Colors.white,
                      style: TextStyle(color: Colors.black),
                      underline: SizedBox(),
                      items: ['Student', 'Staff', 'Admin'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white.withAlpha(204),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white.withAlpha(204),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => authController.isLoading.value
                        ? CircularProgressIndicator()
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withAlpha(128),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (emailController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please fill all fields',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                // Use UserDataService for authentication
                                final userService = UserDataService();
                                final user = await userService.validateLogin(
                                  emailController.text,
                                  passwordController.text,
                                );

                                if (user != null) {
                                  // Check if role matches
                                  if (user.role.toLowerCase() !=
                                      selectedRole.toLowerCase()) {
                                    Get.snackbar(
                                      'Error',
                                      'Invalid credentials for selected role',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  // Show welcome message
                                  Get.snackbar(
                                    'Welcome!',
                                    'Hello ${user.name}',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 2),
                                  );

                                  // Navigate based on role
                                  if (user.role == 'student') {
                                    Get.offNamed('/student/dashboard');
                                  } else if (user.role == 'staff') {
                                    Get.offNamed('/staff/dashboard');
                                  } else if (user.role == 'admin') {
                                    Get.offNamed('/admin/dashboard');
                                  }
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Invalid email or password',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 20),
                  // Quick login hints
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Login:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Student: kathirvel@gmail.com',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          'Staff: vijayakumar@vsb.edu',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          'Admin: admin@vsb.edu',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Password: any',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
