import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialnetworkapp/models/post.dart';
import 'package:socialnetworkapp/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //upload post
  Future<String>uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profileImage

      )async{
    String res = "some error occured";
    try{
      String photoUrl = await StorageMethods().UploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId:postId ,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profileImage,
        likes: [],
        );
      _firestore.collection('posts').doc(postId).set(post.toJson(),);
      res = "success";

    }catch(err){
      res=err.toString();

    }
    return res;

  }
  Future<void>likePost(String postId, String uid, List likes)async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayRemove([uid])
        });
      }else{
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayUnion([uid])
        });
      }

    }catch(e){
      print(e.toString());
    }

  }
  Future<void>postComment(String PostId, String text, String uid, String name, String profilePic )async{
    try{
      if(text.isNotEmpty){
      String commentId = Uuid().v1();
      await _firestore.collection('posts').doc(PostId).collection('comments').doc(commentId).set(
          {
            'profilePic' : profilePic,
            'uid' : uid,
            'name': name,
            'text' : text,
            'datePublished':DateTime.now()
          });
      }else{
        print('text is empty');
      }
    }catch(e){
      print(e.toString());
    }

  }

  //deleting post
Future<void>deletePost(String postId)async{
    try{
    await  _firestore.collection('posts').doc(postId).delete();
    }catch(err){
      print(err.toString());

    }
}
Future<void>followUser(String uid, String followId)async{
    try{
     DocumentSnapshot snapshot =  await _firestore.collection('users').doc(uid).get();
     List following = (snapshot.data()! as dynamic)['following'];
     if(following.contains(followId)){
       await _firestore.collection('users').doc(followId).update({
         'followers':FieldValue.arrayRemove([uid])
       });

       await _firestore.collection('users').doc(uid).update({
         'following':FieldValue.arrayRemove([followId])
       });
     }else{
       await _firestore.collection('users').doc(followId).update({
         'followers':FieldValue.arrayUnion([uid])
       });

       await _firestore.collection('users').doc(uid).update({
         'following':FieldValue.arrayUnion([followId])
       });
     }

    }catch(e){
      print(e.toString());

    }

}



}


