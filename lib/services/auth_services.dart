import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockly/models/user_model.dart';
import 'package:stockly/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object
  Our_User? _userfromFirebase(User user) {
    return user != null
        ? Our_User(uid: user.uid, name: 'new user', Stocks: [])
        : null;
  }

  // user stream detecting authentication change
  Stream<Our_User?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userfromFirebase(user!));
  }

  //email password sign in
  Future SignInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userfromFirebase(user!);
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  //register with email password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // new doc for new user
      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserData('new user', []);
      }
      return _userfromFirebase(user!);
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  //sign out
  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
