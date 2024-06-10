import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson53_todo/services/auth_http_service.dart';
import 'package:lesson53_todo/views/screens/home_screen.dart';
import 'package:lesson53_todo/views/screens/sign_in_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final authHttpService = AuthHttpService();

  String? email, password, password2;
  bool obscurePassword = true;
  bool isLoading = false;

  void checkonSaved() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        await authHttpService.register(email!, password!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return const SignInScreen();
            },
          ),
        );
      } catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email exists";
        }
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("This user already registered"),
              content: Text(message),
            );
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? _checkUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Wrong password";
    }
    return null;
  }

  String? _checkEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter email";
    }
    if (!value.contains("@gmail.com")) {
      return "Wrong email";
    }
    return null;
  }

  String? _checkPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter password";
    }
    if (value.length < 8) {
      return "Wrong password";
    }
    if (_passwordController.text != _confirmController.text) {
      return "Passwords don't match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: _checkEmail,
                onSaved: (newValue) {
                  email = newValue;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        obscurePassword = !obscurePassword;
                        setState(() {});
                      },
                      icon: obscurePassword
                          ? const Icon(CupertinoIcons.eye_slash_fill)
                          : const Icon(CupertinoIcons.eye_solid)),
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                ),
                validator: _checkPassword,
                onSaved: (newValue) {
                  password = newValue;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        obscurePassword = !obscurePassword;
                        setState(() {});
                      },
                      icon: obscurePassword
                          ? const Icon(CupertinoIcons.eye_slash_fill)
                          : const Icon(CupertinoIcons.eye_solid)),
                  labelText: "Confirm password",
                  border: OutlineInputBorder(),
                ),
                validator: _checkUsername,
                onSaved: (newValue) {
                  password2 = newValue;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return const SignInScreen();
                      },
                    ),
                  );
                },
                child: const Text("Sign in"),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: checkonSaved,
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Create account"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
