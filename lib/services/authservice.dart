import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:helloworld/screen/dashboard.dat.dart';
import 'package:helloworld/screen/loginpage.dat.dart';

class AuthService {

  handleAuth(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context,spanshot){
        if(spanshot.hasData){
          return DashboardPage();
        }
        else{
          return LoginPage();
        }
      });
  }

  signOut(){
    FirebaseAuth.instance.signOut();
  }



  signIn(AuthCredential authCreds){
    FirebaseAuth.instance.signInWithCredential(authCreds);

  }

  singInWithOPT(smsCode, verId){
    AuthCredential authcreds = PhoneAuthProvider.getCredential(verificationId: verId, smsCode: smsCode);
    signIn(authcreds);
  }
}