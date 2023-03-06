import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'profile',
  "email",
]);
//nose

Future<String> signWithGoogle() async {

  final GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

  /*final GoogleSignInAccount? _googleSignInAccount = await _googleSignIn(
    scopes: ['email',
      'https://www.googleapis.com/auth/userinfo.profile',],
    hostedDomain: '',
  );*/
  addScopes:presentingViewController:callback:

  final GoogleSignInAuthentication _googleSignInAuthentication =
      await _googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: _googleSignInAuthentication.accessToken,
    idToken: _googleSignInAuthentication.idToken,
  );

  //final AuthResult authResult = await _auth.signInWithCredential(credential);
  final User? user =
      (await FirebaseAuth.instance.signInWithCredential(credential)).user;

  assert(!user!.isAnonymous);
  assert(await user?.getIdToken() != null);

  //final User? currentUser = await _auth.currentUser;

  //assert(user?.uid == currentUser?.uid);
  print("Hola el usuario es: $user");
  return 'Accediste como $user';
}

Future<bool> signOutGoogle() async {
  SharedPreferences prefs = await SharedPreferences. getInstance();
  await prefs.clear();
  await _googleSignIn.signOut();
  print("You are out");
  return true;
}

/*
_saveValue(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> returnValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = await prefs.getString("token");
  return token;
}
*/

