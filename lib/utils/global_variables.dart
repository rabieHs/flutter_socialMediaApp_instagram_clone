import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
final String uid = FirebaseAuth.instance.currentUser!.uid;
const webScreenSize = 600;
List<Widget> HomeScreenItems = [
  const FeedScreen(),
 const SearchScreen(),
 const AddPostScreen(),
 const Text('add'),
  ProfileScreen(uid: uid,),
];