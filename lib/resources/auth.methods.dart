
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialnetworkapp/models/user.dart' as model;
import 'package:socialnetworkapp/resources/storage_method.dart';
class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<model.User> getUserDetails() async{
User currentUser = _auth.currentUser!;
DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();
return model.User.fromSnap(snapshot);
  }

  //sign up
Future<String>SignUp({
        required String email,
        required String password,
        required String username,
        required String bio,
        required Uint8List file,

}        )async{
  String res = "some error occured";
  try{
      if(email.isNotEmpty ||password.isNotEmpty ||username.isNotEmpty ||bio.isNotEmpty ||file != null  ){
        //register the user
       UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

       //upload image
       String PhotoUrl = await StorageMethods().UploadImageToStorage('ProfilePics', file, false);
           //add user to datebase
       model.User user = model.User(
         username:username,
         email:email,
         uid:credential.user!.uid,
         bio:bio,
         followers: [],
         following: [],
         PhotoUrl: PhotoUrl,
       );
       await _firestore.collection('users').doc(credential.user!.uid).set(user.toJson());
       res = "success";
       print(credential.user!.uid);

      }
  }on FirebaseAuthException catch(err){
    if(err.code=='invalid-email'){
      res = 'the email is badly formatted.';
    }
    else if(err.code=='weak-password'){
      res = 'password week.';
    }
  }
  catch(err){
    res = err.toString();
  }
  return res;



}
//login
Future<String>LoginUser({
  required String email,
  required String password
})async{
  String res ="some error occurred";
  try{
    if(email.isNotEmpty||password.isNotEmpty){
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res="sucess";
    }
    else {
      res= "please enter all the fields";
    }
  }catch(err){
    res=err.toString();

  }
  return res;

}
Future<void>signOut()async{
   await _auth.signOut();
}

}