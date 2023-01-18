import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menu/authentication.dart';
import 'package:menu/dayofweek.dart';
import 'package:menu/main.dart';
import 'package:menu/widgets.dart';
import 'package:provider/provider.dart';

class DayOfWeek {
  DayOfWeek(
      {required this.itemID,
      required this.day,
      required this.launch,
      required this.dinner});
  final String itemID;
  final Timestamp? day;
  String? launch;
  String? dinner;

  Map<String, Object?> toMap() {
    return {"day": day, "launch": launch, "dinner": dinner};
  }
}

class WeekPage extends StatefulWidget {
  const WeekPage({Key? key}) : super(key: key);

  @override
  _WeekState createState() => _WeekState();
}

class _WeekState extends State<WeekPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          leading: Icon(Icons.abc),
          title: const Text('My Meal'),
          backgroundColor: Colors.grey[800],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Grocery List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Settings',
            ),
          ],
          currentIndex: 1,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.grey[800],
          showSelectedLabels: true,
          showUnselectedLabels: false,
          //onTap: ()
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AuthFunc(
                    loggedIn: appState.loggedIn,
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
                    child: Text("AGGIUNGI GIORNO"),
                    onPressed: () => {context.push('/details/')}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
