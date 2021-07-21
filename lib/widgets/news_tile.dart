import 'package:flutter/material.dart';

import '../common/colors.dart';

class NewsTile extends StatelessWidget {
  final String title;
  final String body;
  final String date;

  const NewsTile({
    Key key,
    @required this.title,
    this.body,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: const Icon(
            Icons.notifications_active,
            color: MainColors.primary,
          ),
          title: Text(
            title,
            style: textTheme.headline6.copyWith(color: MainColors.primary),
          ),
          trailing: Text(
            date,
            style: textTheme.caption.copyWith(fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(body, style: textTheme.caption.copyWith(fontSize: 16)),
        ),
        const Divider(color: MainColors.primary, indent: 16, endIndent: 16),
      ],
    );
  }
}
