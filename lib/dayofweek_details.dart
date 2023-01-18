import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menu/main.dart';
import 'package:menu/week.dart';
import 'package:menu/widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DayOfWeekDetailsPage extends StatefulWidget {
  const DayOfWeekDetailsPage({super.key, this.itemId});

  final String? itemId;

  @override
  State<DayOfWeekDetailsPage> createState() => _DayOfWeekDetailsPageState();
}

class _DayOfWeekDetailsPageState extends State<DayOfWeekDetailsPage> {
  final _formKey =
      GlobalKey<FormState>(debugLabel: '_DayOfWeekDetailsPageState');
  final _controllerLaunch = TextEditingController();
  final _controllerDinner = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new)),
          title: const Text("Details"),
          backgroundColor: Colors.grey[800],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('dayOfWeeks')
                .doc(widget.itemId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("Loading");
              } else {
                var doc = snapshot.data?.data();
                var dayOfWeek = DayOfWeek(
                    itemID: snapshot.data!.id,
                    day: doc?["day"] ??
                        Timestamp.fromDate(appState.dayOfWeeks.last.day!
                            .toDate()
                            .add(Duration(days: 1))),
                    launch: doc?["launch"],
                    dinner: doc?["dinner"]);
                _controllerLaunch.text = dayOfWeek.launch ?? "";
                _controllerDinner.text = dayOfWeek.dinner ?? "";
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(DateFormat('EEEE DD-MM')
                          .format(dayOfWeek.day!.toDate())),
                      TextFormField(
                        controller: _controllerLaunch,
                        decoration: const InputDecoration(
                          hintText: 'Menu del pranzo',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci il menu per continuare';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _controllerDinner,
                        decoration: const InputDecoration(
                          hintText: 'Menu della cena',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci il menu per continuare';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dayOfWeek.launch = _controllerLaunch.text;
                            dayOfWeek.dinner = _controllerDinner.text;
                            FirebaseFirestore.instance
                                .collection("dayOfWeeks")
                                .doc(widget.itemId)
                                .set(dayOfWeek.toMap());
                            _controllerLaunch.clear();
                            context.pop();
                          }
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.send),
                            SizedBox(width: 4),
                            Text('AGGIORNA'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
