import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menu/applicationstate.dart';
import 'package:menu/authentication.dart';
import 'package:menu/custom_appbar.dart';
import 'package:menu/dayofweek.dart';
import 'package:menu/widgets.dart';
import 'package:provider/provider.dart';

class DayOfWeek {
  DayOfWeek(
      {this.itemID, this.family, required this.day, this.launch, this.dinner});
  String? itemID;
  String? family;
  Timestamp? day;
  String? launch;
  String? dinner;

  Map<String, Object?> toMap() {
    return {"family": family, "day": day, "launch": launch, "dinner": dinner};
  }
}

class WeekPage extends StatefulWidget {
  const WeekPage({Key? key}) : super(key: key);

  @override
  State<WeekPage> createState() => _WeekState();
}

class _WeekState extends State<WeekPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: const CustomAppBar(title: 'My Meal'),
      body: Consumer<ApplicationState>(
        builder: (context, appState, child) => SingleChildScrollView(
          child: Column(
            children: [
              AuthFunc(
                  loggedIn: appState.loggedIn && !appState.isAnonymous,
                  signOut: () {
                    FirebaseAuth.instance.signOut();
                  }),
              ...appState.dayOfWeeks
                  .map(
                    (e) => DayOfWeekPage(
                        itemID: e.itemID,
                        day: e.day,
                        launch: e.launch,
                        dinner: e.dinner),
                  )
                  .toList(),
              StyledButton(
                  child: const Text("AGGIUNGI GIORNO"),
                  onPressed: () => {context.push('/details/')}),
            ],
          ),
        ),
      ),
    );
  }
}
