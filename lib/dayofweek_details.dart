import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menu/week.dart';
import 'package:menu/widgets.dart';

class DayOfWeekDetailsPage extends StatefulWidget {
  DayOfWeekDetailsPage({super.key, required this.itemId});

  String itemId;

  @override
  State<DayOfWeekDetailsPage> createState() => _DayOfWeekDetailsPageState();
}

class _DayOfWeekDetailsPageState extends State<DayOfWeekDetailsPage> {
  final _formKey =
      GlobalKey<FormState>(debugLabel: '_DayOfWeekDetailsPageState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        leading: Icon(Icons.abc),
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
              return new Text("Loading");
            } else {
              var doc = snapshot.data!.data();
              var dayOfWeek = DayOfWeek(itemID: snapshot.data!.id, day: doc!["day"], launch: doc["launch"], dinner: doc["dinner"]);
              _controller.text = dayOfWeek.launch;
              return Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
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
                    ),
                    const SizedBox(width: 8),
                    StyledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dayOfWeek.launch = _controller.text;
                          FirebaseFirestore.instance.collection("dayOfWeeks").doc(widget.itemId).update(
                              dayOfWeek.toMap());
                          _controller.clear();
                          context.pop();
                        }
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.send),
                          SizedBox(width: 4),
                          Text('SEND'),
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
    );
  }
}
