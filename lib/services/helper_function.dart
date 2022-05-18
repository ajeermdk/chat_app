import 'package:shared_preferences/shared_preferences.dart';


class HelperFunctions{

  static String sharedPreferencesUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferencesUserNameKey = "USERNAMEKEY";
  static String sharedPreferencesUserEmailKey = "USEREMAILKEY";


   //saving data to sharedpreferences

  static Future saveUserLoggedInSharedPreferences(bool isUserLoggedIn)async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferencesUserLoggedInKey, isUserLoggedIn);
  }

  static Future saveUserNameSharedPreferences(String userName)async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserNameKey, userName);
  }

  static Future saveUserEmailSharedPreferences(String userEmail)async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserEmailKey, userEmail);
  }

  //getting data from sharedpreferences

   static Future getUserLoggedInSharedPreferences()async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferencesUserLoggedInKey);
  }

  static Future getUserNameSharedPreferences()async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferencesUserNameKey);
  }

  static Future getUserEmailSharedPreferences()async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferencesUserEmailKey);
  }
}