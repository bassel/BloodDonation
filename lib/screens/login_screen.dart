import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';

import '../common/assets.dart';
import '../common/colors.dart';
import '../utils/tools.dart';
import '../utils/validators.dart';
import '../widgets/action_button.dart';
import 'home_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'login';
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  String _emailError, _passError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController?.dispose();
    _passController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.primary,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconAssets.logo),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Login',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _emailField(),
                          const SizedBox(height: 18),
                          _passField(),
                          const SizedBox(height: 32),
                          ActionButton(
                            text: 'Login',
                            callback: _login,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: _resetPassword,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Reset Password',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: MainColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.route);
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'New user? ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Create Account',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailField() => TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        onTap: () => setState(() => _emailError = null),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Email',
          prefixIcon: const Icon(Istos.email),
          errorText: _emailError,
        ),
      );

  Widget _passField() => TextField(
        controller: _passController,
        onTap: () => setState(() => _passError = null),
        obscureText: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Password',
          prefixIcon: const Icon(Istos.locked),
          errorText: _passError,
        ),
      );

  Future<void> _login() async {
    if (_validateFields()) {
      setState(() {
        _emailError = null;
        _passError = null;
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passController.text,
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.route,
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _emailError = 'No user found for that email';
        } else if (e.code == 'wrong-password') {
          _passError = 'Wrong password provided for that user';
        } else {
          Fluttertoast.showToast(msg: e.message);
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again',
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (Tools.isNullOrEmpty(_emailController.text)) {
      setState(() {
        _emailError = '* Please specify your email';
      });
    } else {
      setState(() {
        _emailError = null;
        _passError = null;
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text);
        Fluttertoast.showToast(
          msg: 'Password reset email has been sent. Please check your email',
        );
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: e.message);
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again',
        );
      }
      setState(() => _isLoading = false);
    }
  }

  bool _validateFields() {
    setState(() {
      _emailError = Validators.required(_emailController.text, 'Email');
      _passError = Validators.required(_passController.text, 'Password');
    });

    return _emailError == null && _passError == null;
  }
}
