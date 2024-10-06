import 'package:flutter/material.dart';
import 'package:newproject/pages/login_page.dart';
import 'package:newproject/pages/register_page.dart';
class LoginOrRegisterPage extends StatefulWidget {
 const LoginOrRegisterPage({super.key});
  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}
class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //Initialize Login or Register Page UI here
  bool showLoginPage = true;
  void toggleLoginRegisterPage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap: toggleLoginRegisterPage);
    }
    else{
      return RegisterPage(on_tap: toggleLoginRegisterPage);
    }

  }
}
