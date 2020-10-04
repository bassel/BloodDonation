import 'package:flutter/material.dart';

import '../data/lists/blood_banks.dart';
import '../data/lists/hospitals.dart';
import '../data/lists/lrc_centers.dart';
import '../data/lists/medical_centers.dart';
import '../data/medical_center.dart';

class MedicalCenterPicker extends StatefulWidget {
  const MedicalCenterPicker({Key key}) : super(key: key);

  @override
  _MedicalCenterPickerState createState() => _MedicalCenterPickerState();
}

class _MedicalCenterPickerState extends State<MedicalCenterPicker> {
  final _searchController = TextEditingController();
  MedicalCenterCategory _category = MedicalCenterCategory.hospitals;
  List<MedicalCenter> _centers;

  @override
  void initState() {
    super.initState();
    _centers = hospitals;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final filtered = _centers
        .where((c) =>
            c.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            c.location
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
        .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        isDense: true,
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<MedicalCenterCategory>(
                      value: _category,
                      items: MedicalCenterCategory.values
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.name),
                              ))
                          .toList(),
                      onChanged: (cat) {
                        if (cat == _category) return;

                        switch (cat) {
                          case MedicalCenterCategory.hospitals:
                            _centers = hospitals;
                            break;
                          case MedicalCenterCategory.lrcCenters:
                            _centers = lrcCenters;
                            break;
                          case MedicalCenterCategory.bloodBanks:
                            _centers = bloodBanks;
                            break;
                          case MedicalCenterCategory.medicalCenters:
                            _centers = medicalCenters;
                            break;
                        }
                        setState(() => _category = cat);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: filtered.length,
                itemBuilder: (context, i) => ListTile(
                  dense: true,
                  title: Text(
                    filtered[i].name ?? '',
                    style: textTheme.subtitle1,
                  ),
                  subtitle: Text(
                    filtered[i].location ?? '',
                    style: textTheme.bodyText2
                        .copyWith(color: textTheme.caption.color),
                  ),
                  onTap: () {
                    Navigator.pop(context, filtered[i]);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum MedicalCenterCategory { hospitals, lrcCenters, bloodBanks, medicalCenters }

extension on MedicalCenterCategory {
  String get name {
    switch (this) {
      case MedicalCenterCategory.hospitals:
        return 'Hospitals';
      case MedicalCenterCategory.lrcCenters:
        return 'Red Cross';
      case MedicalCenterCategory.bloodBanks:
        return 'Blood Banks';
      case MedicalCenterCategory.medicalCenters:
        return 'Others';
      default:
        return '';
    }
  }
}
