import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';
import 'package:hive/hive.dart';

import '../common/assets.dart';
import '../common/colors.dart';
import '../common/hive_boxes.dart';
import '../utils/blood_types.dart';
import '../widgets/submitted_blood_requests.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const route = 'profile';
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Linear.pencil),
            onPressed: () {
              Navigator.pushReplacementNamed(context, EditProfileScreen.route);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerImage(user?.photoURL),
            _infoRow(context, user),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 24, 12),
              child: Text(
                'Active Blood Requests:',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: MainColors.primary),
              ),
            ),
            const Expanded(child: SubmittedBloodRequests()),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, User user) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            _bloodIcon(),
            Expanded(
              child: Column(
                children: [
                  Text(
                    user.displayName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 4),
                  Text(user.email, textAlign: TextAlign.center),
                ],
              ),
            ),
            _bloodIcon(),
          ],
        ),
      );

  Widget _bloodIcon() {
    final bloodType = Hive.box(ConfigBox.key)
        .get(ConfigBox.bloodType, defaultValue: BloodType.aPos.name) as String;
    return SvgPicture.asset(
      BloodTypeUtils.fromName(bloodType).icon,
      height: 50,
    );
  }

  Widget _headerImage(String url) => Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: curveHeight,
            child: CustomPaint(painter: _MyPainter()),
          ),
          Hero(
            tag: 'profilePicHero',
            child: Container(
              width: avatarDiameter,
              height: avatarDiameter,
              decoration: const BoxDecoration(
                color: MainColors.accent,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: url != null
                  ? CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white70,
                        ),
                      ),
                    )
                  : SvgPicture.asset(IconAssets.donor),
            ),
          ),
        ],
      );
}

const avatarRadius = 60.0;
const avatarDiameter = avatarRadius * 2;
const curveHeight = avatarRadius * 2.5;

/// Source: https://gist.github.com/tarek360/c94a82f9554caf8f6b62c4fcf140272f
class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = MainColors.primary;

    const topLeft = Offset(0, 0);
    final bottomLeft = Offset(0, size.height * 0.25);
    final topRight = Offset(size.width, 0);
    final bottomRight = Offset(size.width, size.height * 0.25);

    final leftCurveControlPoint =
        Offset(size.width * 0.2, size.height - avatarRadius * 0.8);
    final rightCurveControlPoint = Offset(size.width - leftCurveControlPoint.dx,
        size.height - avatarRadius * 0.8);

    final avatarLeftPoint =
        Offset(size.width * 0.5 - avatarRadius + 5, size.height * 0.5);
    final avatarRightPoint =
        Offset(size.width * 0.5 + avatarRadius - 5, avatarLeftPoint.dy);

    final avatarTopPoint =
        Offset(size.width / 2, size.height / 2 - avatarRadius);

    final path = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(leftCurveControlPoint.dx, leftCurveControlPoint.dy,
          avatarLeftPoint.dx, avatarLeftPoint.dy)
      ..arcToPoint(avatarTopPoint, radius: const Radius.circular(avatarRadius))
      ..lineTo(size.width / 2, 0)
      ..close();

    final path2 = Path()
      ..moveTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..quadraticBezierTo(rightCurveControlPoint.dx, rightCurveControlPoint.dy,
          avatarRightPoint.dx, avatarRightPoint.dy)
      ..arcToPoint(avatarTopPoint,
          radius: const Radius.circular(avatarRadius), clockwise: false)
      ..lineTo(size.width / 2, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
