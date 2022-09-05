import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialnetworkapp/providers/user_provider.dart';
import 'package:socialnetworkapp/responsive/mobile_screen_layout.dart';
import 'package:socialnetworkapp/responsive/responsive_layout_screen.dart';
import 'package:socialnetworkapp/responsive/web_screen_layout.dart';
import 'package:socialnetworkapp/screens/login_screen.dart';
import 'package:socialnetworkapp/screens/signup_screen.dart';
import 'package:socialnetworkapp/utils/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: 'AIzaSyB25ZSqopAr3FG1G9unGfc18BFWhMZ6fwE',
          appId: '1:293660172920:web:90e7a03177328a4606c38d',
          messagingSenderId: '293660172920',
          projectId: '1:293660172920:web:90e7a03177328a4606c38d',
        storageBucket: 'social-app-16e2f.appspot.com',
      ),
    );

  }else{
  await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_)=> UserProvider(),)],
      child: MaterialApp(
        title: 'SocialApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor
        ),

        home:
        StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
            return  const ResponsiveLayout(
                mobileSreenLayout: MobileScreenLayout(),
                webSreenLayout:WebScreenLayout(),
              );

            }else if(snapshot.hasError){
              return(Center(child: Text('${snapshot.error}'),));
            }


          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),);
          }
          return const LoginScreen();

          },
        )
   ),
    );

  }

}
