import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:menu/family.dart';
import 'package:menu/firebase_options.dart';
import 'package:menu/week.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool _isAnonymous = false;
  Family? _family;
  bool get loggedIn => _loggedIn;
  bool get isAnonymous => _isAnonymous;
  Family get family => _family!;

  StreamSubscription<QuerySnapshot>? _dayOfWeekSubscription;
  List<DayOfWeek> _dayOfWeeks = [];
  List<DayOfWeek> get dayOfWeeks => _dayOfWeeks;

  Future getFamilyByUser(User user) async {
    final familySnapshot = await FirebaseFirestore.instance
        .collectionGroup("members")
        .where("uid", isEqualTo: user.uid)
        .get();

    //return familySnapshot.docs.isNotEmpty ? familySnapshot.docs.first : null;

    if (familySnapshot.docs.isNotEmpty) {
      var membersPath =
          '${familySnapshot.docs.first.reference.parent.parent!.path}/members';
      var members =
          (await FirebaseFirestore.instance.collection(membersPath).get())
              .docs
              .map((e) => FamilyMember(e.data()['uid'], e.data()['email'],
                  e.data()['invitePending'], e.data()['invitationDate']))
              .toList();
      _family = Family(
          id: familySnapshot.docs.first.reference.parent.parent!.id,
          name: (await familySnapshot.docs.first.reference.parent.parent!.get())
              .data()!['name'] as String,
          members: members);
    } else {
      var familyReference = await FirebaseFirestore.instance
          .collection('families')
          .add(<String, dynamic>{'name': ''});
      FirebaseFirestore.instance
          .collection('families')
          .doc(familyReference.id)
          .collection('members')
          .add(<String, dynamic>{
        'uid': user.uid,
        'email': user.email,
        'invitePending': false,
        'invitationDate': Timestamp.now()
      });
      _family = Family(id: familyReference.id);
    }
  }

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
        await getFamilyByUser(user);

        _dayOfWeekSubscription = FirebaseFirestore.instance
            .collection('dayOfWeeks')
            .where('family', isEqualTo: _family!.id)
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
                  family: document.data()['family'] as String),
            );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _dayOfWeeks = [];
        _dayOfWeekSubscription?.cancel();
        _family = null;
        await FirebaseAuth.instance.signInAnonymously();
      }
      notifyListeners();
    });
  }
}
