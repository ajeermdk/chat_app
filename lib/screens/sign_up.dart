import 'package:chat_app/screens/chat_rooms.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/helper_function.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signMeUp() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserNameSharedPreferences(_usernameController.text);
      HelperFunctions.saveUserEmailSharedPreferences(_emailController.text);
      setState(() {
        isLoading = true;
      });

      authMethods
          .createAccount(_emailController.text, _passwordController.text)
          .then((value) {
        //print("${value}");
        Map<String, String> userInfoMap = {
          "name": _usernameController.text,
          "email": _emailController.text
        };

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreferences(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const ChatRoom()));
      });
    }
  }

  @override
  void initState() {
    //Firebase.initializeApp();
    super.initState();
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

          // // Once complete, show your application
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
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(45.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Create your Account',
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
                                          hintText: "Username",
                                          hintStyle: TextStyle(
                                            color:
                                                Color.fromARGB(114, 61, 59, 59),
                                            fontSize: 17,
                                          ),
                                        ),
                                        controller: _usernameController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter a name";
                                          } else if (value.length < 3) {
                                            return "Enter atleast 3 characters";
                                          } else {
                                            return null;
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
                                  ),
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  255, 30, 49, 157)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ))),
                                  onPressed: () {
                                    signMeUp();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 57,
                                    child: const Text(
                                      'Sign up',
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
                                        'Or sign up with',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(156, 0, 0, 0)),
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
                                  height: screenHeight / 14,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        color: Color.fromARGB(156, 0, 0, 0),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    InkWell(
                                      child: const Text(
                                        'Sign in',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 30, 49, 157),
                                          //decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const SignIn()));
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
