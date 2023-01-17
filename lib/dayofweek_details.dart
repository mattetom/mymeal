import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DayOfWeekDetailsPage extends StatelessWidget {
  DayOfWeekDetailsPage({super.key, required this.itemId});

  String itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Details"),
        backgroundColor: Colors.grey[800],
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('dayOfWeeks')
                .doc(itemId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return new Text("Loading");
              }
              return Text(snapshot.data!.data()!["launch"]);
            }),
      ),
    );
  }
}
