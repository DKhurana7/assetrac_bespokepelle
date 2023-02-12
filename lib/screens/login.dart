import 'dart:async';

import 'package:assetrac_bespokepelle/main.dart';
import 'package:assetrac_bespokepelle/screens/homepage.dart';
import 'package:assetrac_bespokepelle/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/textformfield.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  bool _obscureText = true;

  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text('AssetRac',
                style: TextStyle(
                    color: Color(0XFF0A233E),
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.asset('images/BespokePelleLogo.jpg'),
            const SizedBox(height: 40),
            TextFormField(
              controller: emailController,
              cursorColor: const Color(0XFF0A233E),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color(0XFF0A233E)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0XFF0A233E))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0XFF0A233E))),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Color(0XFF0A233E),
                  )),
              // // autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email!'
                      : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              cursorColor: const Color(0XFF0A233E),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0XFF0A233E)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0XFF0A233E))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0XFF0A233E))),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color(0XFF0A233E),
                  ),
                  suffixIcon: IconButton(
                    onPressed: toggle,
                    icon: _obscureText
                        ? const Icon(FontAwesomeIcons.eyeSlash,
                            color: Color(0XFF0A233E))
                        : const Icon(
                            FontAwesomeIcons.eye,
                            color: Color(0XFF0A233E),
                          ),
                  )),
              obscureText: _obscureText,
              // // autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? 'Enter min. 6 characters'
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color(0XFF0A233E)),
              icon: const Icon(Icons.lock_open, size: 32),
              label: const Text(
                'Sign In',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signIn,
            ),
            const SizedBox(height: 24),
            GestureDetector(
                child: const Text('Forgot Password?',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0XFF0A233E),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()));
                }),
            const SizedBox(height: 2),
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        color: Color(0XFF0A233E),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    text: 'New User? ',
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'Sign Up',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0XFF0A233E)))
                ]))
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E))),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignIn: toggle);

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text('AssetRac',
                style: TextStyle(
                    color: Color(0XFF0A233E),
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.asset('images/BespokePelleLogo.jpg'),
            const SizedBox(height: 10),
            const SizedBox(height: 40),
            TextFormFieldCard(
                controller: nameController,
                enabled: true,
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                labelText: 'Name',
                prefixIcon: Icons.person,
                validatorText: 'Enter your name!'),
            const SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              cursorColor: const Color(0XFF0A233E),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color(0XFF0A233E)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0XFF0A233E))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0XFF0A233E))),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Color(0XFF0A233E),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      emailController.clear();
                    },
                    icon: const Icon(Icons.clear, color: Color(0XFF0A233E)),
                  )),
              // // autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email!'
                      : null,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: passwordController,
              cursorColor: const Color(0XFF0A233E),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0XFF0A233E)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0XFF0A233E))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0XFF0A233E))),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color(0XFF0A233E),
                  ),
                  suffixIcon: IconButton(
                      onPressed: _toggle,
                      icon: _obscureText
                          ? const Icon(
                              FontAwesomeIcons.eyeSlash,
                              color: Color(0XFF0A233E),
                            )
                          : const Icon(
                              FontAwesomeIcons.eye,
                              color: Color(0XFF0A233E),
                            ))),
              obscureText: _obscureText,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? 'Enter min. 6 characters'
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color(0XFF0A233E)),
              icon: const Icon(Icons.lock_open, size: 32),
              label: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signUp,
            ),
            const SizedBox(height: 24),
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        color: Color(0XFF0A233E),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    text: 'Already have an account? ',
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Log In',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0XFF0A233E)))
                ]))
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E))));
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      userCredential.user!
          .updateDisplayName(nameController.text.trim());


      if (formKey.currentState!.validate() &&
          nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        FirebaseFirestore.instance.collection('users').add({
          'name': nameController.text,
          'email': emailController.text,
          'timestamp': DateTime.now()
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Receive an email to\nreset your password.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                cursorColor: const Color(0XFF0A233E),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Color(0XFF0A233E)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(
                            width: 2.0, color: Color(0XFF0A233E))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(
                            width: 2.0, color: Color(0XFF0A233E))),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color(0XFF0A233E),
                    )),
                // // // autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email!'
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                    backgroundColor: const Color(0XFF0A233E)),
                icon: const Icon(Icons.email_outlined),
                label: const Text('Reset Password',
                    style: TextStyle(fontSize: 24)),
                onPressed: resetPassword,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E))));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('Password Reset Email Sent!');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.pop(context);
    }
  }
}

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Verify Email'),
            centerTitle: true,
            backgroundColor: const Color(0XFF0A233E),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'A verification email has been sent to your email!',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50.0),
                    backgroundColor: const Color(0XFF0A233E)),
                    onPressed: sendVerificationEmail,
                    icon: const Icon(Icons.email, size: 32),
                    label: const Text(
                      'Resend Email',
                      style: TextStyle(fontSize: 24),
                    ))
              ],
            ),
          ),
        );
}
