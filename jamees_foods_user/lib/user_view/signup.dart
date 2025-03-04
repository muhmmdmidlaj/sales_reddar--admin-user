import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_frontend/controller/provider/signup_provider.dart';
import 'package:jamees_foods_frontend/user_view/login.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: Center(
          child: Consumer<SignUpProvider>(
            builder: (context, provider, child) => Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width: 580.w,
                      height: 900.h,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 16.r,
                            offset: Offset(0, 8.h),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20.h),
                              Image.asset(
                                'asset/image/logo.png',
                                height: 70.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 200.w),
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              _buildTextField(
                                controller: provider.usernameController,
                                hint: 'Username',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a username';
                                  }
                                  return null;
                                },
                              ),
                              _buildTextField(
                                controller: provider.phoneNumberController,
                                hint: 'Phone Number',
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number';
                                  } else if (value.length < 10 ||
                                      value.length > 15) {
                                    return 'Phone number must be between 10-15 digits';
                                  }
                                  return null;
                                },
                              ),
                              _buildPasswordField(provider),
                              _buildConfirmPasswordField(provider),
                              SizedBox(height: 25.h),

                              /// SIGNUP BUTTON WITH LOADER
                              SizedBox(
                                height: 80.h,
                                width: 343.w,
                                child: ElevatedButton(
                                  onPressed: provider.isLoading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            await provider.signupUser(context);
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 209, 20, 6),
                                    minimumSize: Size(double.infinity, 50.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: provider.isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                ),
                              ),

                              SizedBox(height: 17.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 209, 20, 6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (provider.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  } 

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: SizedBox(
        width: 343.w,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          keyboardType: keyboardType,
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildPasswordField(SignUpProvider provider) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: SizedBox(
        width: 343.w,
        child: TextFormField(
          controller: provider.passwordController,
          obscureText: provider.isPasswordHidden,
          decoration: InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                provider.isPasswordHidden
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: provider.togglePasswordVisibility,
            ),
          ),
          validator: (value) => (value == null || value.length < 6)
              ? 'Password must be at least 6 characters'
              : null,
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField(SignUpProvider provider) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: SizedBox(
        width: 343.w,
        child: TextFormField(
          controller: provider.confirmPasswordController,
          obscureText: provider.isPasswordHidden,
          decoration: InputDecoration(
            hintText: 'Confirm Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                provider.isPasswordHidden
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: provider.togglePasswordVisibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            } else if (value != provider.passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ),
    );
  }
}
