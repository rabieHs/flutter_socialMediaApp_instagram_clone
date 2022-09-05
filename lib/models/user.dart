import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User{
  final String username;
  final String email;
  final String uid;
  final String bio;
  final List followers ;
  final List following ;
  final String PhotoUrl;


  const User ({required this.email,
    required this.PhotoUrl ,
    required this.uid ,
    required this.bio ,
    required this.username ,
    required this.followers ,
    required this.following,

});
  Map<String , dynamic> toJson()=> {
    "username":username,
    "email":email,
    "uid": uid,
    "bio":bio,
    "followers": followers,
    "following": following,
    "photoUrl": PhotoUrl,

  };
  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String , dynamic>;
    return User(
      username: snapshot['username'],
      email: snapshot['email'],
      PhotoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      following: snapshot['following'],
      followers: snapshot['followers'],
      uid: snapshot['uid'],
    );
  }

}