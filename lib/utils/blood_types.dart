import '../common/assets.dart';

enum BloodType { aPos, aNeg, bPos, bNeg, abPos, abNeg, oPos, oNeg }

extension BloodTypeUtils on BloodType {
  static const bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  static BloodType fromName(String s) {
    switch (s) {
      case 'A+':
        return BloodType.aPos;
      case 'A-':
        return BloodType.aNeg;
      case 'B+':
        return BloodType.bPos;
      case 'B-':
        return BloodType.bNeg;
      case 'AB+':
        return BloodType.abPos;
      case 'AB-':
        return BloodType.abNeg;
      case 'O+':
        return BloodType.oPos;
      case 'O-':
        return BloodType.oNeg;
      default:
        throw AssertionError('Blood type does not exist');
    }
  }

  String get name {
    switch (this) {
      case BloodType.aPos:
        return 'A+';
      case BloodType.aNeg:
        return 'A-';
      case BloodType.bPos:
        return 'B+';
      case BloodType.bNeg:
        return 'B-';
      case BloodType.abPos:
        return 'AB+';
      case BloodType.abNeg:
        return 'AB-';
      case BloodType.oPos:
        return 'O+';
      case BloodType.oNeg:
        return 'O-';
      default:
        throw AssertionError('Blood type does not exist');
    }
  }

  String get icon {
    switch (this) {
      case BloodType.aPos:
        return IconAssets.bloodAPos;
      case BloodType.aNeg:
        return IconAssets.bloodANeg;
      case BloodType.bPos:
        return IconAssets.bloodBPos;
      case BloodType.bNeg:
        return IconAssets.bloodBNeg;
      case BloodType.abPos:
        return IconAssets.bloodABPos;
      case BloodType.abNeg:
        return IconAssets.bloodABNeg;
      case BloodType.oPos:
        return IconAssets.bloodOPos;
      case BloodType.oNeg:
        return IconAssets.bloodONeg;
      default:
        throw AssertionError('Blood type does not exist');
    }
  }

  List<BloodType> get possibleDonors {
    switch (this) {
      case BloodType.aPos:
        return [BloodType.aPos, BloodType.aNeg, BloodType.oPos, BloodType.oNeg];
      case BloodType.aNeg:
        return [BloodType.aNeg, BloodType.oNeg];
      case BloodType.bPos:
        return [BloodType.bPos, BloodType.bNeg, BloodType.oPos, BloodType.oNeg];
      case BloodType.bNeg:
        return [BloodType.bNeg, BloodType.oNeg];
      case BloodType.abPos:
        // can get from all
        return BloodType.values;
      case BloodType.abNeg:
        return [
          BloodType.abNeg,
          BloodType.aNeg,
          BloodType.bNeg,
          BloodType.oNeg
        ];
      case BloodType.oPos:
        return [BloodType.oPos, BloodType.oNeg];
      case BloodType.oNeg:
        return [BloodType.oNeg];
      default:
        return [];
    }
  }

  List<BloodType> get possibleRecipients {
    switch (this) {
      case BloodType.aPos:
        return [BloodType.aPos, BloodType.abPos];
      case BloodType.aNeg:
        return [
          BloodType.aNeg,
          BloodType.aPos,
          BloodType.abNeg,
          BloodType.abPos
        ];
      case BloodType.bPos:
        return [BloodType.bPos, BloodType.abPos];
      case BloodType.bNeg:
        return [
          BloodType.bNeg,
          BloodType.bPos,
          BloodType.abNeg,
          BloodType.abPos
        ];
      case BloodType.abPos:
        return [BloodType.abPos];
      case BloodType.abNeg:
        return [BloodType.abNeg, BloodType.abPos];
      case BloodType.oPos:
        return [
          BloodType.oPos,
          BloodType.aPos,
          BloodType.bPos,
          BloodType.abPos
        ];
      case BloodType.oNeg:
        // Can donate to all
        return BloodType.values;
      default:
        return [];
    }
  }
}
