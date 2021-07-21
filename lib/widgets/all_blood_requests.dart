import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/assets.dart';
import '../common/styles.dart';
import '../data/blood_request.dart';
import '../widgets/blood_request_tile.dart';

class AllBloodRequests extends StatefulWidget {
  const AllBloodRequests({Key key}) : super(key: key);

  @override
  _AllBloodRequestsState createState() => _AllBloodRequestsState();
}

class _AllBloodRequestsState extends State<AllBloodRequests> {
  Stream<QuerySnapshot<Map<String, dynamic>>> _query;

  @override
  void initState() {
    super.initState();
    _query = FirebaseFirestore.instance
        .collection('blood_requests')
        .where('isFulfilled', isEqualTo: false)
        .orderBy('requestDate')
        .limit(30)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _query,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'Could not fetch blood requests',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.docs.isEmpty) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
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
              ),
            );
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  return BloodRequestTile(
                    request: BloodRequest.fromJson(
                      snapshot.data.docs[i].data(),
                      id: snapshot.data.docs[i].id,
                    ),
                  );
                },
                childCount: snapshot.data.size,
              ),
            );
          }
        }

        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
