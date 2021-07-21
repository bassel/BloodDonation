import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../common/assets.dart';
import '../common/colors.dart';
import '../common/hive_boxes.dart';
import '../utils/blood_types.dart';
import '../widgets/action_button.dart';

class EditProfileScreen extends StatefulWidget {
  static const route = 'edit-profile';
  const EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

const kProfileDiameter = 120.0;

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _bloodType;
  User _oldUser;
  bool _isLoading = false;

  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = user.displayName;
    _emailController.text = user.email;
    _oldUser = user;
    _bloodType = Hive.box(ConfigBox.key)
        .get(ConfigBox.bloodType, defaultValue: BloodType.aPos.name) as String;
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _imageRow(),
                  const SizedBox(height: 36),
                  _nameField(),
                  const SizedBox(height: 18),
                  _emailField(),
                  const SizedBox(height: 18),
                  _bloodTypeSelector(),
                  const SizedBox(height: 36),
                  ActionButton(
                    text: 'Save',
                    callback: _save,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageRow() => InkWell(
        onTap: _getImage,
        borderRadius: BorderRadius.circular(90),
        child: Container(
          width: kProfileDiameter,
          height: kProfileDiameter,
          decoration: const BoxDecoration(
            color: MainColors.accent,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (_image != null)
                Image.file(
                  _image,
                  fit: BoxFit.cover,
                  height: kProfileDiameter,
                  width: kProfileDiameter,
                )
              else if (_oldUser.photoURL != null)
                CachedNetworkImage(
                  imageUrl: _oldUser.photoURL,
                  height: kProfileDiameter,
                  width: kProfileDiameter,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white70,
                    ),
                  ),
                )
              else
                SvgPicture.asset(IconAssets.donor),
              Container(
                height: 30,
                width: kProfileDiameter,
                color: MainColors.primary,
                child: const Icon(Istos.upload, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      );

  Widget _nameField() => TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name',
          prefixIcon: Icon(Istos.person),
        ),
      );

  Widget _emailField() => TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          prefixIcon: Icon(Istos.email),
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

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        String newProfileUrl;
        if (_image != null) {
          Fluttertoast.showToast(msg: 'Uploading Image...');
          final snapshot = FirebaseStorage.instance
              .ref()
              .child('avatars/${user.uid}')
              .putFile(_image)
              .snapshot;
          newProfileUrl = snapshot.ref.getDownloadURL() as String;
        }
        if (_nameController.text != _oldUser.displayName ||
            newProfileUrl != null) {
          await user.updateDisplayName(_nameController.text);
          await user.updatePhotoURL(newProfileUrl);
        }
        if (_emailController.text != _oldUser.email) {
          await user.updateEmail(_emailController.text);
        }
        final initialBloodType = Hive.box(ConfigBox.key)
                .get(ConfigBox.bloodType, defaultValue: BloodType.aPos.name)
            as String;
        if (_bloodType != initialBloodType) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'bloodType': _bloodType});
          Hive.box(ConfigBox.key).put(ConfigBox.bloodType, _bloodType);
        }
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(msg: e.message);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
      }
      setState(() => _isLoading = false);
    }
  }
}
