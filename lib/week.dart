import 'package:flutter/material.dart';
import 'package:menu/dayofweek.dart';

class WeekPage extends StatelessWidget {
  const WeekPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              DayOfWeekPage(
                dayOfWeek: 'Lunedì',
                lunch: 'Tagliatelle al ragu',
                dinner: 'Toast con verdure fresche'),
              DayOfWeekPage(
                dayOfWeek: 'Martedì',
                lunch: 'Tagliatelle al ragu',
                dinner: 'Toast con verdure fresche'),
              DayOfWeekPage(
                dayOfWeek: 'Mercoledì',
                lunch: 'Tagliatelle al ragu',
                dinner: 'Toast con verdure fresche'),
              DayOfWeekPage(
                dayOfWeek: 'Mercoledì',
                lunch: 'Tagliatelle al ragu',
                dinner: 'Toast con verdure fresche'),
              DayOfWeekPage(
                dayOfWeek: 'Mercoledì',
                lunch: 'Tagliatelle al ragu',
                dinner: 'Toast con verdure fresche'),
              DayOfWeekPage(
                dayOfWeek: 'Mercoledì',
                lunch: 'Tagliatelle al ragu',
                dinner: 'Toast con verdure fresche'),
            ],
          ),
        ),
      ),
    );
  }
}
