import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_rider/Screens/loginpage.dart';
import 'package:flutter_app_rider/Screens/mainpage.dart';
import 'package:flutter_app_rider/brand_colors.dart';
import 'package:flutter_app_rider/widgets/ProgressDialog.dart';
import 'package:flutter_app_rider/widgets/TaxiButton.dart';

class RegistrationPage extends StatefulWidget {

  static const String id = 'register';


  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var uid;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {

    //show please Wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Registering you...',),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      uid = userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        showSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      showSnackBar(e);
    }

    Navigator.pop(context);
    if (uid != null) {
      DatabaseReference newUserRef = FirebaseDatabase.instance.reference()
          .child('user/${uid}');
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };

      newUserRef.set(userMap);

      //take a user to the main page
      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
      //Navigator.of(context).pushNamedAndRemoveUntil(MainPage.id, (route) => false);

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

                Text('Create a Rider\'s Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                       //full name
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
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

                      //email Address
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

                      //phone number
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
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

                      //password
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
                        title: 'REGISTER',
                        color: BrandColors.colorGreen,
                        onPressed: () async {

                          //check network availability
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi)
                            {
                              showSnackBar('No internet connectivity!');
                              return;
                            }


                          if(fullNameController.text.length < 3)
                            {
                              showSnackBar('Please provide a valid fullname ');
                              return;
                            }
                          if(phoneController.text.length < 10)
                            {
                              showSnackBar('Please provide a valid phone-number');
                              return;
                            }
                          if(!emailController.text.contains('@')){
                            showSnackBar('Please provide a valid email address');
                            return;
                          }
                          if(passwordController.text.length < 8 )
                          {
                            showSnackBar('Password must be at least 8 characters');
                            return;
                          }

                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                  },
                  child: Text('Already have a Rider\'s account? Log in'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
