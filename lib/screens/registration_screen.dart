import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';

import '../common/assets.dart';
import '../common/colors.dart';
import '../utils/blood_types.dart';
import '../utils/validators.dart';
import '../widgets/action_button.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const route = 'register';
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  String _nameError, _emailError, _passError, _bloodType = 'A+';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController?.dispose();
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
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(IconAssets.logo),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Register',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _nameField(),
                      const SizedBox(height: 18),
                      _emailField(),
                      const SizedBox(height: 18),
                      _passField(),
                      const SizedBox(height: 18),
                      _bloodTypeSelector(),
                      const SizedBox(height: 32),
                      ActionButton(
                        text: 'Register',
                        callback: _register,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameField() => TextField(
        controller: _nameController,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        onTap: () => setState(() => _nameError = null),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Name',
          prefixIcon: const Icon(Istos.person),
          errorText: _nameError,
        ),
      );

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

  Widget _bloodTypeSelector() => DropdownButtonFormField<String>(
        value: _bloodType,
        onChanged: (v) => setState(() => _bloodType = v),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Blood Type',
          prefixIcon: Icon(Istos.blood_drop),
        ),
        items: BloodTypeUtils.bloodTypes
            .map((v) => DropdownMenuItem(
                  value: v,
                  child: Text(v),
                ))
            .toList(),
      );

  Future<void> _register() async {
    if (_validateFields()) {
      setState(() {
        _nameError = null;
        _emailError = null;
        _passError = null;
        _isLoading = true;
      });
      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passController.text,
        );
        await userCredential.user.updateDisplayName(_nameController.text);
        final users = FirebaseFirestore.instance.collection('users');
        await users.doc(userCredential.user.uid).set({
          'bloodType': _bloodType,
          'isAdmin': false,
        }, SetOptions(merge: true));
        userCredential.user.sendEmailVerification();
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.route,
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _passError = 'The password provided is too weak';
        } else if (e.code == 'email-already-in-use') {
          _emailError = 'The account already exists for that email';
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

  bool _validateFields() {
    setState(() {
      _nameError = Validators.required(_nameController.text, 'Name');
      _emailError = Validators.required(_emailController.text, 'Email');
      _passError = Validators.required(_passController.text, 'Password');
    });

    return _nameError == null && _emailError == null && _passError == null;
  }
}
