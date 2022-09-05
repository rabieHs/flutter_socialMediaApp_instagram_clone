import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialnetworkapp/resources/auth.methods.dart';
import 'package:socialnetworkapp/resources/firestore_method.dart';
import 'package:socialnetworkapp/screens/login_screen.dart';
import 'package:socialnetworkapp/utils/colors.dart';
import 'package:socialnetworkapp/utils/global_variables.dart';
import 'package:socialnetworkapp/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../widgets/follow_button.dart';
class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key ,required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData={};
  var mydata={};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  int othersPosts=0;
  String roomId='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getMyDetails();
  }
  getMyDetails()async{
    try{
    var snapMe = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    mydata = snapMe.data()!;
    }catch(e){

    }

  }


  getData()async{
    setState(() {
      isLoading = true;
    });
    try {
      var Usersnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      //get post length
      var postSnapshot = await FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      postLen = postSnapshot.docs.length;

      userData = Usersnapshot.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing= userData['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      var OtherUsersPost = await FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get();
      othersPosts = OtherUsersPost.docs.length;
      setState(() {

      });
    }catch(e){
      showSnackBar(e.toString(), context);

    }
    setState(() {
      isLoading = false;
    });
  }




  ///Create chatRom and send user to conversation screen

  /*StartConversation(String myname, String username){

    String RoomId = myname+username;
    List<String> users = [myname,username];
    Map<String,dynamic> chatRoomMap= {
      "users": users,
      "chatRoomId":RoomId,
      "userId":userData['uid']

    };



    FirestoreMethods().CreateChatRoom(RoomId, chatRoomMap);
    setState(() {
      roomId = RoomId;
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ConversationScreen(
      snap:userData,
      idroom:roomId,
      myname:mydata['username']

    )));



  }*/


  @override
  Widget build(BuildContext context) {





    return isLoading ? const Center(child: CircularProgressIndicator(),) :Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username']),
        centerTitle: false,

      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 40,

                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BuilsStateColumn((widget.uid)== FirebaseAuth.instance.currentUser!.uid ? postLen:othersPosts, 'posts'),
                              BuilsStateColumn(followers, 'followers'),
                              BuilsStateColumn(following, 'following'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid ?
                              FollowButton(text: 'Sign Out',
                                BorderColor: Colors.grey,
                                BackgroundColor: mobileBackgroundColor,
                                textColor: Colors.red,
                                function: ()async{
                                await  AuthMethods().signOut();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                },)
                                  :isFollowing? Row(
                                    children: [
                                      FollowButton(text: 'Unfollow',
                                BorderColor: Colors.grey,
                                BackgroundColor:Colors.white,
                                textColor: Colors.black,
                                function: ()async{
                                        await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                },),


                                    ],
                                  )
                                  :FollowButton(text: 'follow',
                                BorderColor: Colors.blue,
                                BackgroundColor: Colors.blue,
                                textColor: Colors.white,
                                function: ()async{
                                  await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                  setState(() {
                                    isFollowing = true;
                                    followers++;
                                  });
                                },)
                            ],
                          )
                        ],
                      ),
                    ),

                  ],

                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(userData['username'],style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(userData['bio']),
                ),
              ],

            ),
          ),
          const Divider(color: Colors.white,),
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                    itemCount:(snapshot.data! as dynamic).docs.length ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 1.5,childAspectRatio: 1),
                    itemBuilder: (context, index){
                    DocumentSnapshot snap= (snapshot.data! as dynamic).docs[index];
                    return Container(
                      child: Image(
                        image: NetworkImage(snap['postUrl']

                        ),
                        fit:BoxFit.cover ,
                      ),
                    );
                    });
              }

          )

        ],
      ),
    );
  }
  Column BuilsStateColumn(int number, String label){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(number.toString(),style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
    ),),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(label,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,
            color: Colors.grey
          ),),
        ),
      ]
    );

  }
}
