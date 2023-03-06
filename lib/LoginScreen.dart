import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'homScreem.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController mailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState(){
    checkUserAuth();
    super.initState();
  }

  checkUserAuth() async {
    try {
      User user = auth.currentUser!; // use the null-aware operator
      if (user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      }
    } catch (e) {
      print("Error A " + e.toString());
    }
  }

  // Método para iniciar sesión
  login() async {
    String email = mailController.text;
    String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
        User user = result.user!;

        //Registrar clave FCM
        String? token = await firebaseMessaging.getToken();
        await db.collection("users").doc(user.uid).set({
          "email": user.email,
          "fcmToken": token,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } catch (e) {
/*
        showToast("Error " + e.toString(), gravity: Toast.CENTER);
*/
      }
    } else {
/*
      showToast("Ingrese correo electrónico y contraseña", gravity: Toast.CENTER);
*/
    }
  }

/*

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: mailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Password",
                    labelText: "Password"),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            MaterialButton(
              color: Colors.green,
              child: Text("Login"),
              onPressed: () {
                login();
              },
            )
          ],
        ),
      ),
    );
  }
}
