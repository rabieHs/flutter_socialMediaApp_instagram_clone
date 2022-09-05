import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialnetworkapp/providers/user_provider.dart';
import 'package:socialnetworkapp/resources/firestore_method.dart';
import 'package:socialnetworkapp/utils/colors.dart';
import 'package:socialnetworkapp/utils/utils.dart';
import 'package:web_ffi/web_ffi.dart';

import '../models/user.dart';
class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void PostImage(String uid , String username , String profileImage)async{
    setState(() {
      _isLoading = true;
    });
    try{
      String res = await FirestoreMethods().uploadPost(_descriptionController.text, _file!, uid, username, profileImage);
      if (res=="success"){
        setState(() {
          _isLoading = false;
        });
        showSnackBar('posted!', context);
        clearImage();
      }else{
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }

    }catch(e){
      showSnackBar(e.toString(), context);

    }

  }

  _selectImage(BuildContext context) async{
    return showDialog(context: context, builder: (context){


      return SimpleDialog(
        title: const Text('create a Post'),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text('Take a Photo'),
            onPressed:() async{
              Navigator.of(context).pop();
              Uint8List file = await PickImage(ImageSource.camera);
              setState(() {
                _file = file ;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text('Choose from Gallery'),
            onPressed:() async{
              Navigator.of(context).pop();
              Uint8List file = await PickImage(ImageSource.gallery);
              setState(() {
                _file = file ;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed:() {
              Navigator.of(context).pop();

            },
          ),
        ],
      );
    });

  }
  void clearImage(){
    setState(() {
      _file = null;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null? Center(
      child: IconButton(
        icon: const Icon(Icons.upload),
        onPressed: ()=> _selectImage(context),

      ),
    ):
     Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back) ,
        onPressed: clearImage,
        ),
        title: const Text('Post to'),
        actions: [
          TextButton(onPressed:()=> PostImage(user.uid, user.username, user.PhotoUrl),
              child: const Text('Post',style: TextStyle(
              color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,),
          )
          )
        ],

      ),
      body: Column(
        children: [
          _isLoading? const LinearProgressIndicator():
          const Padding(padding: EdgeInsets.only(top: 0),),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.PhotoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.4,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Write a Caption...',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                        image:DecorationImage(
                          image:MemoryImage(_file!),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                        )  ),
                  ),
                ),
              ),
              const Divider(),
            ],
          )
        ],
      ),
    );
  }
}
