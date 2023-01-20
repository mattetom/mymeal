import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:menu/dayofweek_details.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/week.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WeekPage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  if (state is SignedIn || state is UserCreated) {
                    var user = (state is SignedIn)
                        ? state.user
                        : (state as UserCreated).credential.user;
                    if (user == null) {
                      return;
                    }
                    if (state is UserCreated) {
                      user.updateDisplayName(user.email!.split('@')[0]);
                    }
                    if (!user.emailVerified) {
                      user.sendEmailVerification();
                      const snackBar = SnackBar(
                          content: Text(
                              'Please check your email to verify your email address'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    context.pushReplacement('/');
                  }
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.queryParams;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
        GoRoute(
          path: 'details/:itemID',
          builder: (context, state) {
            return DayOfWeekDetailsPage(itemId: state.params["itemID"]);
          },
        ),
        GoRoute(
          path: 'details',
          builder: (context, state) {
            return const DayOfWeekDetailsPage();
          },
        ),
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Menu',
      theme: ThemeData.from(colorScheme: const ColorScheme.dark()).copyWith(
        buttonTheme: Theme.of(context)
            .buttonTheme
            .copyWith(highlightColor: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme:
            GoogleFonts.frederickaTheGreatTextTheme(Theme.of(context).textTheme)
                .apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      routerConfig: _router,
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool _isAnonymous = false;
  String _family = "";
  bool get loggedIn => _loggedIn;
  bool get isAnonymous => _isAnonymous;
  String get family => _family;

  StreamSubscription<QuerySnapshot>? _dayOfWeekSubscription;
  List<DayOfWeek> _dayOfWeeks = [];
  List<DayOfWeek> get dayOfWeeks => _dayOfWeeks;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;
        _isAnonymous = user.isAnonymous;
        // retrieve family
        var familyQuery = await FirebaseFirestore.instance.collection('families').where('members', arrayContains: user.uid).get();
        var familyDoc = familyQuery.docs;
        if(familyDoc.isEmpty) {
          var familyReference = await FirebaseFirestore.instance
                          .collection('families')
                          .add(<String, dynamic>{'members': [user.uid]});
          _family = familyReference.id;
        } else {
          _family = familyDoc.first.id;
        }
        _dayOfWeekSubscription = FirebaseFirestore.instance
            .collection('dayOfWeeks')
            .where('family', isEqualTo: _family)
            .orderBy('day', descending: false)
            .snapshots()
            .listen((snapshot) {
          _dayOfWeeks = [];
          for (final document in snapshot.docs) {
            _dayOfWeeks.add(
              DayOfWeek(
                itemID: document.id,
                day: document.data()['day'] as Timestamp,
                launch: document.data()['launch'] as String,
                dinner: document.data()['dinner'] as String,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _dayOfWeeks = [];
        _dayOfWeekSubscription?.cancel();
        _family = "";
        await FirebaseAuth.instance.signInAnonymously();
      }
      notifyListeners();
    });
  }
}
