import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson53_todo/services/auth_http_service.dart';
import 'package:lesson53_todo/views/screens/home_screen.dart';
import 'package:lesson53_todo/views/screens/register_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authHttpService = AuthHttpService();
  String? email;
  String? password;
  bool obscurePassword = true;
  bool isLoading = false;

  void checkonSaved() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        await _authHttpService.login(email!, password!);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } on Exception catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email mavjud";
        }
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Xatolik"),
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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in"),
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
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot password",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text("Create new account"),
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: checkonSaved,
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Sign in"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
