import 'package:flutter/material.dart';

import '../common/colors.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final Color backgroundColor;
  final bool isLoading;
  final double radius;

  const ActionButton({
    @required this.callback,
    @required this.text,
    this.backgroundColor = MainColors.primary,
    this.isLoading = false,
    this.radius = 5.0,
  });

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
          : RaisedButton(
              onPressed: callback,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              color: backgroundColor,
              textColor: Colors.white,
              disabledTextColor: Colors.white,
              child: Text(text, style: const TextStyle(fontSize: 18)),
            ),
    );
  }
}
