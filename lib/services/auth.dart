import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/model/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  

  TheUser? _userFromFirebaseUser(User user) {
    return user != null ? TheUser(userId: user.uid) : null;
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future createAccount(String email, String password) async {
    try {
       UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);
    } on FirebaseAuthException catch(e){
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future resetPassword(String email)async{
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch(e){
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      return'success';
    } on FirebaseAuthException catch(e){
      return e.message;
    } catch (e) {
      rethrow;
    }
  }
}


