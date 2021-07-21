import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/medical_center.dart';
import '../utils/blood_types.dart';
import '../utils/tools.dart';
import '../utils/validators.dart';
import '../widgets/action_button.dart';
import '../widgets/medical_center_picker.dart';

class AddBloodRequestScreen extends StatefulWidget {
  static const route = 'add-request';
  const AddBloodRequestScreen({Key key}) : super(key: key);

  @override
  _AddBloodRequestScreenState createState() => _AddBloodRequestScreenState();
}

class _AddBloodRequestScreenState extends State<AddBloodRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _noteController = TextEditingController();
  String _bloodType = 'A+';
  MedicalCenter _medicalCenter;
  DateTime _requestDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _patientNameController?.dispose();
    _contactNumberController?.dispose();
    _noteController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const elementsSpacer = SizedBox(height: 16);
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Blood Request')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _patientNameField(),
                  elementsSpacer,
                  _contactNumberField(),
                  elementsSpacer,
                  _bloodTypeSelector(),
                  elementsSpacer,
                  _medicalCenterSelector(),
                  elementsSpacer,
                  _requestDatePicker(),
                  elementsSpacer,
                  _noteField(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: ActionButton(
                      callback: _submit,
                      text: 'Submit',
                      isLoading: _isLoading,
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

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        final requests =
            FirebaseFirestore.instance.collection('blood_requests');
        await requests.add({
          'uid': user.uid,
          'submittedBy': user.displayName,
          'patientName': _patientNameController.text,
          'bloodType': _bloodType,
          'contactNumber': _contactNumberController.text,
          'note': _noteController.text,
          'submittedAt': DateTime.now(),
          'requestDate': _requestDate,
          'isFulfilled': false,
          'medicalCenter': _medicalCenter.toJson(),
        });
        _resetFields();
        Fluttertoast.showToast(msg: 'Request successfully Submitted');
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _patientNameField() => TextFormField(
        controller: _patientNameController,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        validator: (v) => Validators.required(v, 'Patient name'),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Patient Name',
        ),
      );

  Widget _contactNumberField() => TextFormField(
        controller: _contactNumberController,
        keyboardType: TextInputType.phone,
        validator: (v) =>
            Validators.required(v, 'Contact number') ?? Validators.phone(v),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Contact number',
          prefixText: '+961 ',
        ),
      );

  Widget _noteField() => TextFormField(
        controller: _noteController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        minLines: 3,
        maxLines: 5,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Notes (Optional)',
          alignLabelWithHint: true,
        ),
      );

  Widget _bloodTypeSelector() => DropdownButtonFormField<String>(
        value: _bloodType,
        onChanged: (v) => setState(() => _bloodType = v),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Blood Type',
        ),
        items: BloodTypeUtils.bloodTypes
            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
            .toList(),
      );

  Widget _medicalCenterSelector() => GestureDetector(
        onTap: () async {
          final picked = await showModalBottomSheet<MedicalCenter>(
            context: context,
            builder: (_) => const MedicalCenterPicker(),
            isScrollControlled: true,
          );
          if (picked != null) {
            setState(() => _medicalCenter = picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            key: ValueKey<String>(_medicalCenter?.name ?? 'none'),
            initialValue: _medicalCenter?.name,
            validator: (_) => _medicalCenter == null
                ? '* Please select a medical center'
                : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Medical Center',
            ),
          ),
        ),
      );

  Widget _requestDatePicker() => GestureDetector(
        onTap: () async {
          final today = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: today,
            firstDate: today,
            lastDate: today.add(const Duration(days: 365)),
          );
          if (picked != null) {
            setState(() => _requestDate = picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            key: ValueKey<DateTime>(_requestDate ?? DateTime.now()),
            initialValue: Tools.formatDate(_requestDate),
            validator: (_) =>
                _requestDate == null ? '* Please select a date' : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Request date',
              helperText: 'The date on which you need the blood to be ready',
            ),
          ),
        ),
      );

  void _resetFields() {
    _patientNameController.clear();
    _contactNumberController.clear();
    _noteController.clear();
    setState(() {
      _requestDate = null;
      _medicalCenter = null;
    });
  }
}
