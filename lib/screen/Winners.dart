
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/services/authservice.dart';

class Winner  extends StatefulWidget{
  @override
  _WinnerPageState createState() =>_WinnerPageState();

}

class _WinnerPageState  extends State<Winner>{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
            child: Text('Winners')
        )
    );
  }

}
