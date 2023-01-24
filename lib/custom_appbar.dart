import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  final String title;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.abc),
      title: Text(title),
      actions: [
        IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.person))
      ],
      backgroundColor: Colors.grey[800],
    );
  }
}
