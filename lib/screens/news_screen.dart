import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../utils/tools.dart';
import '../widgets/news_tile.dart';

class NewsScreen extends StatelessWidget {
  static const route = 'news';
  const NewsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final news = FirebaseFirestore.instance.collection('news');

    return Scaffold(
      appBar: AppBar(title: const Text('News and Tips')),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: news.orderBy('date', descending: true).limit(20).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(MainColors.primary),
                ),
              );
            }

            return ListView(
              children: snapshot.data.docs.map((doc) {
                return NewsTile(
                  title: doc.data()['title'] as String,
                  body: doc.data()['body'] as String,
                  date: Tools.formatDate(
                    (doc.data()['date'] as Timestamp).toDate(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
