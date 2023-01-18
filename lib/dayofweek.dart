import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DayOfWeekPage extends StatelessWidget {
  final String itemID;
  final Timestamp? day;
  final String? launch;
  final String? dinner;

  const DayOfWeekPage(
      {Key? key,
      required this.itemID,
      required this.day,
      required this.launch,
      required this.dinner})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        color: Colors.grey[900],
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (day != null) ? DateFormat('EEEE').format(day!.toDate()) : "",
                  style: TextStyle(fontSize: 40),
                ),
              ),
              ListTile(
                //leading: Icon(Icons.no_meals),
                title: Text('PRANZO'),
                subtitle: Text(launch ?? ""),
              ),
              ListTile(
                //leading: Icon(Icons.no_meals),
                title: Text('CENA'),
                subtitle: Text(dinner ?? ""),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('EDIT'),
                    onPressed: () {
                      context.push('/details/' + itemID);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
