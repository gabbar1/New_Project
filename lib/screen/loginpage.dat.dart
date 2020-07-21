
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/screen/OTP.dart';
import 'package:helloworld/services/authservice.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'CustomInputField.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() =>_LoginPageState();


}

class _LoginPageState extends  State<LoginPage>{
  final formKey  = new  GlobalKey<FormState>();
  String phoneNo,verficationId,smsCode,mob;
  bool codeSent = false;
  final DBRef = FirebaseDatabase.instance.reference();

sendData(){
  DBRef.child("Users").child(phoneNo).set({
    'MobileNumber':phoneNo,
    'Name':'Enter Your Name'

  });
}

  final _formKey = GlobalKey<FormState>();
  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70),
          child: Text(
            'LUCK',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    Text(
                      "Login",

                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),

                    ),

                  ],

                ),
                _phone(),
                _otp(),
                _verify()

              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _phone(){
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
            ),
            labelText: 'Phone Number',
            labelStyle: TextStyle(
    //     color:Colors.yellow[600],
    ),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(11.0),
            ),
          ),
          onChanged: (val){
            setState(() {
              this.phoneNo = val;
            });
            },)
    );

  }
  Widget _otp(){

    return codeSent ?  Padding(
        padding: EdgeInsets.only(left: 25.0,right: 25.0),
        child: TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
            ),
            labelText: 'Enter OTP ',
            labelStyle: TextStyle(

            ), border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(11.0),
          ),
          ),
          onChanged: (val){
            setState(() {
              this.smsCode = val;
            });
          },
        )): Container();
  }
  Widget _verify(){
    return Padding(
        padding: EdgeInsets.only(left: 25.0,right: 25.0),
        child: RaisedButton(
            child: Center(
                child: codeSent ? Text('Login'): Text('Verify')
            ),elevation: 5.0,
            color: Colors.yellow[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>OPT()),);
              codeSent ?  AuthService().singInWithOPT(smsCode, verficationId) : verifyPhone(phoneNo);
              codeSent? "":sendData();

            }));
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(70),
                    bottomRight: const Radius.circular(70),
                  ),
                ),
              ),
            ),
            Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLogo(),
                _buildContainer(),


              ],
            )
          ],
        ),
      ),
    );
  }
  Future<void>  verifyPhone(phoneNo) async{
    final PhoneVerificationCompleted verified  = (AuthCredential authResult){
      AuthService().signIn(authResult);
    };
    final PhoneVerificationFailed verificationFailed  = (AuthException authException){
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent  = (String verId,[int forceResend]){
      this.verficationId = verId;
      setState(() {
        this.codeSent=true;
      });
    };

    final  PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId){
      this.verficationId=verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent, codeAutoRetrievalTimeout: autoTimeout);
  }
}


