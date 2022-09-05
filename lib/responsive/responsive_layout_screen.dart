import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialnetworkapp/utils/global_variables.dart';

import '../providers/user_provider.dart';
class ResponsiveLayout extends StatefulWidget {

  final Widget webSreenLayout;
  final Widget mobileSreenLayout;
  const ResponsiveLayout({Key? key, required this.webSreenLayout, required this.mobileSreenLayout,}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }
  addData()async{
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth > webScreenSize){
        return widget.webSreenLayout;
        }
      return widget.mobileSreenLayout;
    },

    );
  }
}
