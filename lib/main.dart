import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:menu/applicationstate.dart';
import 'package:menu/dayofweek_details.dart';
import 'package:menu/grocery_list.dart';
import 'package:menu/scaffold_with_bottom_nav_bar.dart';
import 'package:menu/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/week.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/sign-in',
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
      path: '/profile',
      builder: (context, state) {
        return ProfileScreen(
          appBar: AppBar(
            title: const Text('User Profile'),
          ),
          providers: const [],
          actions: [
            SignedOutAction((context) {
              context.pushReplacement('/');
            }),
          ],
          children: [
            const Text('My family'),
            Consumer<ApplicationState>(
                builder: (context, appState, child) => Column(
                    children: appState.family.members
                            ?.map((e) => Text(e.email))
                            .toList() ??
                        [])),
            StyledButton(
                child: const Text("Invite member"), onPressed: () => {}),
          ],
        );
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const WeekPage(),
          ),
          routes: [
            GoRoute(
              path: 'details/:itemID',
              builder: (context, state) {
                return DayOfWeekDetailsPage(
                    itemId: state.params.containsKey('itemID')
                        ? state.params["itemID"]
                        : null);
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
        GoRoute(
          path: '/groceryList',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const GroceryListPage(),
          ),
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
      debugShowCheckedModeBanner: false,
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
