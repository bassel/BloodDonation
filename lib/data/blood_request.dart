import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../utils/blood_types.dart';
import 'medical_center.dart';

class BloodRequest {
  final String id;
  final String uid, submittedBy, patientName, contactNumber, note;
  final BloodType bloodType;
  final DateTime submittedAt, requestDate;
  final MedicalCenter medicalCenter;
  bool isFulfilled;

  BloodRequest({
    @required this.id,
    @required this.uid,
    @required this.submittedBy,
    @required this.patientName,
    @required this.contactNumber,
    @required this.bloodType,
    @required this.medicalCenter,
    @required this.submittedAt,
    @required this.requestDate,
    this.note,
    this.isFulfilled = false,
  });

  factory BloodRequest.fromJson(Map<String, dynamic> json, {String id}) =>
      BloodRequest(
        id: id,
        uid: json['uid'] as String,
        submittedBy: json['submittedBy'] as String,
        patientName: json['patientName'] as String,
        contactNumber: json['contactNumber'] as String,
        bloodType: BloodTypeUtils.fromName(json['bloodType'] as String),
        medicalCenter: MedicalCenter.fromJson(
          json['medicalCenter'] as Map<String, dynamic>,
        ),
        submittedAt: (json['submittedAt'] as Timestamp).toDate(),
        requestDate: (json['requestDate'] as Timestamp).toDate(),
        note: json['note'] as String,
        isFulfilled: json['isFulfilled'] as bool,
      );
}
