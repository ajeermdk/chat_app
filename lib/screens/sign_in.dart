import 'package:chat_app/screens/account_screen.dart';
import 'package:chat_app/screens/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../services/helper_function.dart';
import '../widgets/search_widget.dart';
import 'chat_rooms.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final formKey = GlobalKey<FormState>();

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;

  signMeIn() async {
    if (formKey.currentState!.validate()) {
      //HelperFunctions.saveUserNameSharedPreferences(_usernameController.text);

      await HelperFunctions.saveUserEmailSharedPreferences(
          _emailController.text);
      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByUserEmail(_emailController.text).then((value) {
        snapshotUserInfo = value;
        HelperFunctions.saveUserNameSharedPreferences(
            snapshotUserInfo?.docs[0].get("name"));
      });
      authMethods
          .signIn(_emailController.text, _passwordController.text)
          .then((value) {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreferences(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (ctx) => const ChatRoom()));
        }
      });

      //databaseMethods.uploadUserInfo(userInfoMap);

    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          // if (snapshot.hasError) {
          //   return const Center(
          //     child: Text('Something went wrong'),
          //   );
          // }

          // Once complete, show your application
          // if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: isLoading
                ? const SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight / 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Image(
                                    width: screenWidth / 2,
                                    image: const AssetImage(
                                        'assets/images/bubble_logo2.png'),
                                  ),
                                  const Text(
                                    'lets chat!',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.amber),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(45.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Login to your Account',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Color.fromARGB(175, 0, 0, 0)),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(193, 85, 81, 81),
                                        ),
                                        decoration: const InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                          //filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    105, 97, 97, 103),
                                                width: 0.7),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  90, 126, 123, 135),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                            color:
                                                Color.fromARGB(114, 61, 59, 59),
                                            fontSize: 17,
                                          ),
                                        ),
                                        controller: _emailController,
                                        validator: (value) {
                                          if (RegExp(
                                                  "^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*")
                                              .hasMatch(value!)) {
                                            return null;
                                          } else {
                                            return "please provide a valid email address";
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(193, 85, 81, 81),
                                        ),
                                        decoration: const InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                          //filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    105, 97, 97, 103),
                                                width: 0.7),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  90, 126, 123, 135),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                            color:
                                                Color.fromARGB(114, 61, 59, 59),
                                            fontSize: 17,
                                          ),
                                        ),
                                        controller: _passwordController,
                                        validator: (value) {
                                          if (value!.length < 6) {
                                            return "please provide atleast 6 characters";
                                          } else {
                                            return null;
                                          }
                                        },
                                        obscureText: true,
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 30, 49, 157),
                                      //decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    //print('link taped');
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(255, 30, 49, 157)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ))),
                                onPressed: () {
                                  signMeIn();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 57,
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Or sign in with',
                                      style: TextStyle(
                                          color: Color.fromARGB(156, 0, 0, 0)),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //print('google taped');
                                      },
                                      child: Image.asset(
                                        'assets/images/google-logo.png',
                                        width: 50,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 9,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: Color.fromARGB(156, 0, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  InkWell(
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 30, 49, 157),
                                        //decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const SignUp()));
                                      //print('link taped');
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
          );
        }
        //return const SizedBox();
        );
  }
}
