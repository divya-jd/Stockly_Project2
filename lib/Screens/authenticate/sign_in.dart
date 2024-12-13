import 'package:flutter/material.dart';
import 'package:stockly/services/auth_services.dart';
import 'package:stockly/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field states
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return loading
        ? const Loading()
        : Scaffold(
            body: Container(
              color: isDarkTheme
                  ? const Color(0xFF121212)
                  : const Color(0xFFFFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // App Logo
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage: const AssetImage('assets/logo.png'),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sign in to access your account",
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkTheme
                                ? Colors.grey[400]
                                : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Email Field
                        TextFormField(
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter your email' : null,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(
                              Icons.email,
                              color:
                                  isDarkTheme ? Colors.tealAccent : Colors.teal,
                            ),
                            filled: true,
                            fillColor: isDarkTheme
                                ? const Color(0xFF1E1E1E)
                                : const Color(0xFFF5F5F5),
                            labelStyle: TextStyle(
                              color: isDarkTheme
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                              color: isDarkTheme ? Colors.white : Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // Password Field
                        TextFormField(
                          validator: (val) => val!.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color:
                                  isDarkTheme ? Colors.tealAccent : Colors.teal,
                            ),
                            filled: true,
                            fillColor: isDarkTheme
                                ? const Color(0xFF1E1E1E)
                                : const Color(0xFFF5F5F5),
                            labelStyle: TextStyle(
                              color: isDarkTheme
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                              color: isDarkTheme ? Colors.white : Colors.black),
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        // Sign In Button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.SignInWithEmailAndPassword(
                                      email, password);
                              if (result is String) {
                                setState(() {
                                  error =
                                      result.substring(result.indexOf("]") + 1);
                                  loading = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkTheme
                                ? const Color(0xFF3F51B5)
                                : const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Register Redirect
                        TextButton(
                          onPressed: () {
                            widget.toggleView();
                          },
                          child: Text(
                            "Don't have an account? Register",
                            style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.tealAccent
                                  : const Color(0xFF0072FF),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Error Message
                        if (error.isNotEmpty)
                          Text(
                            error,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
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
