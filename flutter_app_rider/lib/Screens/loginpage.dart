import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rider/Screens/mainpage.dart';
import 'package:flutter_app_rider/Screens/registrationpage.dart';
import 'package:flutter_app_rider/brand_colors.dart';
import 'package:flutter_app_rider/widgets/ProgressDialog.dart';
import 'package:flutter_app_rider/widgets/TaxiButton.dart';

class LoginPage extends StatefulWidget {

  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var uid;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void logIn() async{

    //show please Wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging you in',),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
      );
      uid = userCredential.user.uid;
    }
    on FirebaseAuthException catch (e)
    {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showSnackBar('No user found for that email.'
            'Please enter a valid email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showSnackBar('Wrong password provided for that user.');
      }
    }catch (e){
      print (e);
      showSnackBar(e);

    }

    if(uid != null) {
      DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('user/${uid}');
      newUserRef.once().then((DataSnapshot dataSnapshot) =>
      {
        if(dataSnapshot.value != null){
          //take a user to the main page
          Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false),
        }
      });
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 70,),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/logo.png'),
                ),

                SizedBox(height: 40,),

                Text('Sign In As A Rider',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

             Padding(
               padding:  EdgeInsets.all(20.0),
               child: Column(
                 children: <Widget>[

                   TextField(
                     controller: emailController,
                     keyboardType: TextInputType.emailAddress,
                     decoration: InputDecoration(
                       labelText: 'Email address',
                       labelStyle: TextStyle(
                         fontSize: 14.0,
                       ),
                       hintStyle: TextStyle(
                         color: Colors.grey,
                         fontSize: 10.0,
                       ),
                     ),
                     style: TextStyle(fontSize: 14),
                   ),

                   SizedBox(height: 10,),

                   TextField(
                     controller: passwordController,
                     obscureText: true,
                     decoration: InputDecoration(
                       labelText: 'Password',
                       labelStyle: TextStyle(
                         fontSize: 14.0,
                       ),
                       hintStyle: TextStyle(
                         color: Colors.grey,
                         fontSize: 10.0,
                       ),
                     ),
                     style: TextStyle(fontSize: 14),
                   ),

                   SizedBox(height: 40,),

                   TaxiButton(
                     title: 'LOGIN',
                     color: BrandColors.colorGreen,
                     onPressed: () async{

                       //check network availability
                       var connectivityResult = await Connectivity().checkConnectivity();
                       if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
                         showSnackBar('No internet connectivity!');
                         return;
                       }

                       if(!emailController.text.contains('@')){
                         showSnackBar('Please enter a valid email address');
                         return;
                       }

                       if(passwordController.text.length < 8){
                         showSnackBar('Please enter a valid password');
                         return;
                       }

                       logIn();

                     },
                   ),

                 ],
               ),
             ),
                FlatButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                  },
                    child: Text('Don\'t have an account, Sign Up here '),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}



