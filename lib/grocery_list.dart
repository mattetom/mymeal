import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:menu/applicationstate.dart';
import 'package:menu/widgets.dart';
import 'package:provider/provider.dart';

/// Widget for the root/initial pages in the bottom navigation bar.
class GroceryListPage extends StatelessWidget {
  /// Creates a RootScreen
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('')
                //'${snapshot.data?.docs.first.reference.path}/groceryListItems')
                .add({'checked': false, 'value': ""});
          }),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("groceryList")
            .where('family',
                isEqualTo: Provider.of<ApplicationState>(context).family.id)
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(
                        '${snapshot.data?.docs.first.reference.path}/groceryListItems')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final groceryListItems = snapshot.data?.docs;
                  if (groceryListItems!.isEmpty) {
                    return const Text("Your grocery list is empty!");
                  }
                  return ListView.builder(
                      itemCount: groceryListItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Checkbox(
                            value: groceryListItems[index]["checked"],
                            onChanged: (bool? value) {
                              FirebaseFirestore.instance
                                  .doc(groceryListItems[index].reference.path)
                                  .set({
                                'checked': value ?? false,
                                'value': groceryListItems[index]["value"]
                              });
                            },
                          ),
                          title: Text(groceryListItems[index]["value"] ?? ""),
                        );
                      });
                });
          }
        },
      ),
    );
  }
}
