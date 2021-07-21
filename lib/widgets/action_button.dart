import 'package:flutter/material.dart';

import '../common/colors.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final Color backgroundColor;
  final bool isLoading;
  final double radius;

  const ActionButton({
    Key key,
    @required this.callback,
    @required this.text,
    this.backgroundColor = MainColors.primary,
    this.isLoading = false,
    this.radius = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(MainColors.primary),
              ),
            )
          : ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(backgroundColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                )),
              ),
              onPressed: callback,
              child: Text(text, style: const TextStyle(fontSize: 18)),
            ),
    );
  }
}
