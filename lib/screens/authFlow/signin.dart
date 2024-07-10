import 'package:flutter/material.dart';
import 'package:tonner_app/model/login_model.dart';
import 'package:tonner_app/network/ApiService.dart';
import 'package:tonner_app/pref_manager.dart';
import 'package:tonner_app/screens/authFlow/utils.dart';

import '../../color/colors.dart';
import '../../globals.dart';
import '../home/home.dart';

class AuthProcess extends StatefulWidget {
  const AuthProcess({Key? key}) : super(key: key);

  @override
  _AuthProcessState createState() => _AuthProcessState();
}

class _AuthProcessState extends State<AuthProcess> {
  bool isPhoneInput = true; // Flag to track whether to show phone input or email input
  final ApiService apiService = ApiService();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  // Method to toggle between phone input and email input
  void toggleInputType() {
    setState(() {
      isPhoneInput = !isPhoneInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            // Removed const from padding
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                // Removed const from SizedBox
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/ic_tracesci.png',
                    fit: BoxFit.contain,
                    height: 70, // Adjust height as needed
                  ),
                ),
                SizedBox(height: 50),
                // Removed const from SizedBox
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10), // Removed const from SizedBox
                    Text(
                      "Welcome to the app",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 70), // Removed const from SizedBox
                    Text(
                      isPhoneInput ? "Phone number" : "Email",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5), // Removed const from SizedBox
                  ],
                ),
                isPhoneInput
                    ? IntlPhoneInputTextField(
                        controller: phoneController,
                      )
                    : EmailInputTextField(
                        controller: emailController,
                      ),
                // Dynamic widget, removed const
                SizedBox(height: 10),
                // Removed const from SizedBox
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Implement forgot password functionality
                          },
                          child: Text(
                            "Forgot password",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5), // Removed const from SizedBox
                  ],
                ),
                PasswordInputTextField(
                  controller: passwordController,
                ),
                SizedBox(height: 60),
                // Removed const from SizedBox
                GestureDetector(
                  onTap: () {
                    showSnackBar(context, "Clicked on login");
                  },
                  child: SizedBox(
                    child: GradientButton(
                      gradientColors: [colorFirstGrad, colorSecondGrad],
                      // Removed const from gradientColors
                      height: 45.0,
                      width: 10.0,
                      radius: 25.0,
                      buttonText: "Sign in",
                      // Dynamic text, removed const
                      onPressed: () {
                        validateAndSignIn();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Removed const from SizedBox
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        // Removed const from margin
                        child: Divider(
                          color: Colors.grey,
                          height: 36,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add your navigation or action here
                        // For example, navigate to another screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "or sign in with",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        // Removed const from margin
                        child: Divider(
                          color: Colors.grey,
                          height: 36,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Removed const from SizedBox
                SizedBox(
                  child: GradientButton(
                      gradientColors: [colorMixGrad, colorMixGrad],
                      // Removed const from gradientColors
                      height: 45.0,
                      width: 10.0,
                      radius: 25.0,
                      buttonText: isPhoneInput ? "Email" : "Phone number",
                      // Dynamic text, removed const
                      onPressed: () {
                        toggleInputType(); // Toggle between phone and email input
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validateAndSignIn() async {
    // Validate phone number
    if (isPhoneInput) {
      if (phoneController.text.isEmpty) {
        showSnackBar(context, "Phone number is required.");
        return;
      }
      // Additional phone number validation can be added here
    } else {
      // Validate email
      if (emailController.text.isEmpty) {
        showSnackBar(context, "Email is required.");
        return;
      }
      // Additional email validation can be added here
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      showSnackBar(context, "Password is required.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Call the login API
    try {
      final ApiService apiService = ApiService();
      late final Map<String, dynamic> loginResponse;

      // Determine whether to use phone or email for login
      if (isPhoneInput) {
        loginResponse = await apiService.login(
            null, phoneController.text, passwordController.text);
      } else {
        loginResponse = await apiService.login(
            emailController.text, null, passwordController.text);
      }

      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Check if the login was successful based on the response structure
      if (loginResponse.containsKey('error') &&
          loginResponse.containsKey('status')) {
        if (!loginResponse['error'] && loginResponse['status'] == 200) {
          // Successful login

          // Check specific success message
          if (loginResponse['message'] == 'Success') {
            // Extract token and handle it
            User user = User.fromJson(loginResponse['data']['user']);
            String token = user.token;
            // final token = loginResponse['data']['user'][['token']];
            if (token.isNotEmpty) {

              PrefManager().setToken(token.toString());
              PrefManager().setUserName(user.name.toString());
              PrefManager().setUserEmail(user.email.toString());
              PrefManager().setUserPhone(user.phone.toString());
              PrefManager().setUserRole(user.userRole.toString());
              PrefManager().setUserStatus(user.isActive.toString());


              // Navigate to home screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            } else {
              showSnackBar(context, "Token not found in response.");
            }
          } else {
            showSnackBar(context, loginResponse['message']);
          }
        } else {
          // Login failed
          showSnackBar(context, "Login failed. Please check your credentials.");
        }
      } else {
        // Unexpected response structure
        showSnackBar(context,
            "Unexpected response from server. Please try again later.");
      }
    } catch (e) {
      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Handle API errors
      showSnackBar(
          context, "Failed to connect to the server. Please try again later.");
      print("Login API Error: $e");
    }
  }

  }
