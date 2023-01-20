import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Screen Grocery List',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
          ],
        ),
      ),
    );
  }
}
