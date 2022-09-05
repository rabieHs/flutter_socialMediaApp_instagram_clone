import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socialnetworkapp/resources/auth.methods.dart';
import 'package:socialnetworkapp/screens/signup_screen.dart';
import 'package:socialnetworkapp/utils/colors.dart';
import 'package:socialnetworkapp/utils/utils.dart';
import 'package:socialnetworkapp/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _pswdController.dispose();
  }
  void LoginUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().LoginUser(email: _emailController.text, password: _pswdController.text);
    if(res =="success"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const ResponsiveLayout(
        mobileSreenLayout: MobileScreenLayout(),
        webSreenLayout:WebScreenLayout(),
      )));

      
    }else{
    showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }
  void NavigateToSignUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              InkWell(onTap: LoginUser,
                child: Container(

                  child:_isLoading? const Center(child: CircularProgressIndicator(color: primaryColor,),): const Text('Log in'),
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
                    onTap: NavigateToSignUp,

                    child: Container(
                      child: const Text("Sign up.",style: TextStyle(fontWeight: FontWeight.bold),),
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
