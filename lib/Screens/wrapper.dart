import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:stockly/models/user_model.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Our_User?>(context);
    if(user == null) {
      return Authenticate();
    } else{
      return Home();
    }

  }
}


