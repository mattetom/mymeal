import 'package:cloud_firestore/cloud_firestore.dart';

class Family {
  Family(
      {required this.id, this.name, List<FamilyMember>? members});
  String id;
  String? name;
  List<FamilyMember>? members;

}

class FamilyMember {
  
  String uid;
  String email;
  bool invitePending = false;
  Timestamp invitationDate;
  
  FamilyMember(this.uid, this.email, this.invitePending, this.invitationDate);

  Map<String,String> toMap() {
    return {"email": email, "invitePending":invitePending .toString(), "invitationDate": invitationDate.toString()};
  }
}