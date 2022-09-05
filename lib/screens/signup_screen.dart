import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialnetworkapp/resources/auth.methods.dart';
import 'package:socialnetworkapp/screens/login_screen.dart';
import 'package:socialnetworkapp/utils/colors.dart';
import 'package:socialnetworkapp/utils/utils.dart';
import 'package:socialnetworkapp/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _pswdController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }
  void SelectImage()async{
   Uint8List im =  await PickImage(ImageSource.gallery);
   setState(() {
     _image = im;

   });
  }
  void SignUpUser()async{
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().SignUp(
      email: _emailController.text,
      password: _pswdController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file : _image!,
    );
    if(res !='success'){
      showSnackBar(res, context);

    }else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const ResponsiveLayout(
          mobileSreenLayout: MobileScreenLayout(),
        webSreenLayout:WebScreenLayout(),
      )));

    }
    setState(() {
      _isLoading = false;
    });
  }
  void NavigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              //image
              SvgPicture.asset(
                'assets/logo.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64),
              //circular widget for avatar picture
              Stack(
                children: [
                  _image != null ?
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),

                  )
                  :CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/avatar.png'),

                  ),
                  Positioned(
                    bottom:3,
                    left: 70,
                    child: IconButton(
                    onPressed: (){SelectImage();},
                      icon: const Icon(Icons.add_a_photo),
                    ),
                    ),

                ],
              ),
              const SizedBox(height: 24),
              //textfield username
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(
                height: 24,
              ),

              //textfield email
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              //textfield password
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _pswdController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              //textfield bio
              TextFieldInput(
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: SignUpUser ,
                child: Container(

                  child: _isLoading? const Center(child: CircularProgressIndicator(color: primaryColor,),):const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              //transition to sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    child: const Text("Don't have an account?"),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: NavigateToLogin,

                    child: Container(
                      child: const Text("Login.",style: TextStyle(fontWeight: FontWeight.bold),),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

