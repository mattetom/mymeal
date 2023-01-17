import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayOfWeekPage extends StatelessWidget {
  final Timestamp day;
  final String launch;
  final String dinner;

  const DayOfWeekPage(
      {Key? key, required this.day, required this.launch, required this.dinner})
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
                  DateFormat('EEEE').format(day.toDate()),
                  style: TextStyle(fontSize: 40),
                ),
              ),
              ListTile(
                //leading: Icon(Icons.no_meals),
                title: Text('PRANZO'),
                subtitle: Text(launch),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.white,
                  onPressed: () async {
                    String value = await showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        value: launch,
                      ),
                    );
                    log(value);
                  },
                ),
              ),
              ListTile(
                //leading: Icon(Icons.no_meals),
                title: Text('CENA'),
                subtitle: Text(dinner),
                trailing: Icon(Icons.edit, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Dialog extends StatefulWidget {
  @override
  _DialogState createState() => _DialogState();

  final String value;

  Dialog({
    required this.value,
  });
}

class _DialogState extends State<Dialog> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_LaunchDialog');
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Inserisci un piatto',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter a value to continue';
            }
            return null;
          },
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context), child: Text('cancel')),
        ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _controller.clear();
                Navigator.pop(context, _controller.text);
              }
            },
            child: Text('confirm')),
      ],
    );
  }
}
