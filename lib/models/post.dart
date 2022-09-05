import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Post{
  final String username;
  final String postId;
  final String uid;
  final String description;
  final String postUrl;
  final String profImage ;
  final datePublished;
  final likes;


  const Post ({required this.postId,
    required this.description ,
    required this.uid ,
    required this.postUrl ,
    required this.username ,
    required this.profImage ,
    required this.datePublished,
    required this.likes,

  });
  Map<String , dynamic> toJson()=> {
    "username":username,
    "description":description,
    "uid": uid,
    "postUrl":postUrl,
    "profImage": profImage,
    "datePublished": datePublished,
    "postId": postId,
    "likes": likes,


  };
  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String , dynamic>;
    return Post(
      username: snapshot['username'],
      description: snapshot['description'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      datePublished: snapshot['datePublished'],
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      likes: snapshot['likes'],
    );
  }

}