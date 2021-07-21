import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/assets.dart';
import '../common/styles.dart';
import '../data/blood_request.dart';
import 'blood_request_tile.dart';

class SubmittedBloodRequests extends StatefulWidget {
  final bool activeOnly;

  const SubmittedBloodRequests({
    Key key,
    this.activeOnly = true,
  }) : super(key: key);

  @override
  _SubmittedBloodRequestsState createState() => _SubmittedBloodRequestsState();
}

class _SubmittedBloodRequestsState extends State<SubmittedBloodRequests> {
  Future<QuerySnapshot<Map<String, dynamic>>> _submittedRequests;

  @override
  void initState() {
    super.initState();
    if (widget.activeOnly) {
      _submittedRequests = FirebaseFirestore.instance
          .collection('blood_requests')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .where('isFulfilled', isEqualTo: false)
          .orderBy('submittedAt', descending: true)
          .get();
    } else {
      _submittedRequests = FirebaseFirestore.instance
          .collection('blood_requests')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .orderBy('submittedAt', descending: true)
          .limit(20)
          .get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: _submittedRequests,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Could not fetch submitted requests',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(IconAssets.bloodBag, height: 140),
                  const SizedBox(height: 16),
                  const Text(
                    'No requests yet!',
                    style: TextStyle(fontFamily: Fonts.logo, fontSize: 20),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.size,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return BloodRequestTile(
                  request: BloodRequest.fromJson(
                    snapshot.data.docs[i].data(),
                    id: snapshot.data.docs[i].id,
                  ),
                );
              },
            );
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
