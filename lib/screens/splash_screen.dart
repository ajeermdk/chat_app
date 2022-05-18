import 'package:chat_app/screens/chat_rooms.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/services/helper_function.dart';
import 'package:flutter/material.dart';
bool isUserLoggedIn = false;
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    getUserLoggedInState();
    gotoHome();
    super.initState();
  }

  getUserLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreferences().then((value) {
      setState(() {
        isUserLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 49, 157),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 2.5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image(
                    width: screenWidth / 1.8,
                    image: const AssetImage('assets/images/bubble_logo.png'),
                  ),
                  const Text(
                    'lets chat!',
                    style: TextStyle(fontSize: 18, color: Colors.amber),
                  )
                ],
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ));
  }

  Future<void> gotoHome() async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => isUserLoggedIn ? const ChatRoom() : const SignIn()));
  }
}
