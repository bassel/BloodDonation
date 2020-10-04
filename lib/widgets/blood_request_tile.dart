import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../data/blood_request.dart';
import '../screens/single_request_screen.dart';
import '../utils/blood_types.dart';
import '../utils/tools.dart';

const kBorderRadius = 12.0;

class BloodRequestTile extends StatelessWidget {
  final BloodRequest request;

  const BloodRequestTile({Key key, this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient Name', style: textTheme.caption),
                      Text(request.patientName ?? ''),
                      const SizedBox(height: 12),
                      Text('Location', style: textTheme.caption),
                      Text(
                        '${request.medicalCenter.name} - ${request.medicalCenter.location}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Needed By', style: textTheme.caption),
                    Text(Tools.formatDate(request.requestDate) ?? ''),
                    const SizedBox(height: 12),
                    Text('Blood Type', style: textTheme.caption),
                    Text(request.bloodType.name ?? ''),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SingleRequestScreen(request: request),
              ));
            },
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(kBorderRadius),
              bottomLeft: Radius.circular(kBorderRadius),
            ),
            child: Ink(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: MainColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(kBorderRadius),
                  bottomLeft: Radius.circular(kBorderRadius),
                ),
              ),
              child: Center(
                child: Text(
                  'Details',
                  style: textTheme.button.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
