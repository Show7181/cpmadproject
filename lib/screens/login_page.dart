import 'package:flutter/material.dart';

import '../services/firebaseauth_service.dart';
import '../screens/home_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
   _LoginPageState createState() => _LoginPageState();

}

class  _LoginPageState extends State <LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool signUp = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Seng Huat'),
        backgroundColor: const Color(0xFFD8900A),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
         Padding(
  padding: const EdgeInsets.all(12.0),
  child: TextField(
    controller: emailController,
    decoration: InputDecoration(
      labelText: 'Email',
      labelStyle: const TextStyle(color: Color(0xFFD8900A)), 
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD8900A)), 
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD8900A)), 
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD8900A)), 
      ),
    ),
  ),
),
Padding(
  padding: const EdgeInsets.all(12.0),
  child: TextField(
    controller: passwordController,
    obscureText: true,
    decoration: InputDecoration(
      labelText: 'Password',
      labelStyle: const TextStyle(color: Color(0xFFD8900A)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD8900A)), 
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD8900A)), 
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD8900A)), 
      ),
    ),
  ),
),
if (signUp) 
  Padding(
    padding: const EdgeInsets.all(12.0),
    child: TextField(
      controller: usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: const TextStyle(color: Color(0xFFD8900A)), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD8900A)), 
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD8900A)), 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD8900A)), 
        ),
      ),
    ),
  ),


              ElevatedButton(
                onPressed:() async {
                  if(signUp){
                    var newuser = await FirebaseAuthService().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                       username: usernameController.text.trim(),
                    );
                    if(newuser != null){
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const HomePage())
                      );
                    }
                  }
                  else{
                    var reguser = await FirebaseAuthService().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    if(reguser != null){
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const HomePage())
                      );
                    }
                  }
              },
                 style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD8900A), 
            ),
              child: signUp ? const Text('Sign Up') : const Text('Sign In'),
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    signUp = !signUp;
                  });
              }, style: TextButton.styleFrom(
    foregroundColor: const Color(0xFFD8900A), 
  ),
              child: signUp
                ? const Text('Have an account? Sign in')
                : const Text('Create an acoount'),
              )
        ],
      )
    );
  }
}