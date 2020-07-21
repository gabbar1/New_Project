
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OPT extends StatefulWidget{
  @override
  _OTPState createState() =>_OTPState();

}


class _OTPState extends State<OPT>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurpleAccent,
              Colors.purple,
            ],
            begin: Alignment.topRight,
          )),
        child: OtpScreen(),
      ),
    );
  }

}

class OtpScreen extends StatefulWidget{
  @override
  _OtpScreenState createState() => _OtpScreenState();

}

class _OtpScreenState extends State<OtpScreen>{
  List<String> currentPin = ["","","",""];
  TextEditingController pinOneController= TextEditingController();
  TextEditingController pinTwoController= TextEditingController();
  TextEditingController pinThreeController= TextEditingController();
  TextEditingController pinFourController= TextEditingController();
  var outLineInputBorder  = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.transparent),
  );
  int pinIndex  = 0;

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Column(
       children: <Widget>[
         buildExitButton(),
         Expanded(
           child: Container(
             alignment: Alignment(0,0.5),
             padding: EdgeInsets.symmetric(horizontal: 16.0),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 buildSecurityText(),
                 SizedBox(height: 40.0),
                 buildPinRow(),
               ],
             ),
           ),
         ),
         buildNumberPad(),
       ],
     ),
   );

  }

  buildNumberPad(){
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n:1,
                    onPressed:(){
                      pinIndexSetup("1");
                    },
                  ),
                  KeyboardNumber(
                    n:2,
                    onPressed:(){
                      pinIndexSetup("2");
                    },
                  ),
                  KeyboardNumber(
                    n:3,
                    onPressed:(){
                      pinIndexSetup("3");
                    },
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n:4,
                    onPressed:(){
                      pinIndexSetup("4");
                    },
                  ),
                  KeyboardNumber(
                    n:5,
                    onPressed:(){
                      pinIndexSetup("5");
                    },
                  ),
                  KeyboardNumber(
                    n:6,
                    onPressed:(){
                      pinIndexSetup("6");
                    },
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n:7,
                    onPressed:(){
                      pinIndexSetup("7");
                    },
                  ),
                  KeyboardNumber(
                    n:8,
                    onPressed:(){
                      pinIndexSetup("8");
                    },
                  ),
                  KeyboardNumber(
                    n:9,
                    onPressed:(){
                      pinIndexSetup("9");
                    },
                  ),

                ],
              ),  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      onPressed: null,
                      child: SizedBox(),
                    ),
                  ),
                  KeyboardNumber(
                    n:0,
                    onPressed:(){
                      pinIndexSetup("0");
                    },
                  ),
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),

                      ),
                      onPressed: (){
                        clearPin();
                      },
                      child: Image.asset("images/delete.png",color: Colors.white,),
                    ),
                  )

                ],
              ),



            ],
          ),

        ),
      ),
    );
  }

  clearPin(){
    if(pinIndex==0)
      pinIndex=0;
    else if (pinIndex==4){
      setPin(pinIndex, "");
      currentPin[pinIndex -1 ]="";
      pinIndex--;
    }
    else{
      setPin(pinIndex, "");
      currentPin[pinIndex-1]="";
      pinIndex--;
    }
  }

  pinIndexSetup(String text){
    if(pinIndex==0)
      pinIndex=1;
    else if (pinIndex<4) pinIndex++;
      setPin(pinIndex,text);
      currentPin[pinIndex-1] =text;
      String strPin = "";
      currentPin.forEach((e) {
        strPin +=e;
      });
      if(pinIndex==4) print(strPin);

    }
  setPin(int n,String text){
    switch(n){
      case 1 :
        pinOneController.text= text;
        break;
      case 2 :
        pinTwoController.text= text;
        break;
      case 3 :
        pinThreeController.text= text;
        break;
      case 4 :
        pinFourController.text= text;
        break;
    }
  }

  buildPinRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PINNumber(
          outlineInputBorder:outLineInputBorder,
          textEditingController:pinOneController,
        ),
        PINNumber(
          outlineInputBorder:outLineInputBorder,
          textEditingController:pinTwoController,
        ),
        PINNumber(
          outlineInputBorder:outLineInputBorder,
          textEditingController:pinThreeController,
        ),
        PINNumber(
          outlineInputBorder:outLineInputBorder,
          textEditingController:pinFourController,
        )
      ],

    );
  }
  buildSecurityText(){
    return Text(
      "Security PIN ",
      style: TextStyle(
        color: Colors.white70,
        fontSize: 21.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  buildExitButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: (){
              Navigator.pop(context);
            },
            height: 50.0,
            minWidth: 50.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Icon(Icons.clear,color: Colors.white,),
          ),
        )
      ],
    );
  }
  }

  


class PINNumber extends StatelessWidget{

  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;
  PINNumber({this.textEditingController,this.outlineInputBorder});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50.0,
        child: TextField(
          controller: textEditingController,
          enabled: false,
          obscureText: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(contentPadding: EdgeInsets.all(16.0)   ,
              border: outlineInputBorder,
          filled: true,
          fillColor: Colors.white30,
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21.0,
            color: Colors.white,
          ),

        ),

    );
  }
  
}

class KeyboardNumber extends StatelessWidget{
  final int n;
  final Function() onPressed;
  KeyboardNumber({this.n,this.onPressed});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 60.0,
        height: 60.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
        color: Colors.purpleAccent.withOpacity(0.1),

      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        height: 90.0,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24*MediaQuery.of(context).textScaleFactor,
            color: Colors.white,
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
    );


  }

}