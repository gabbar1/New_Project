
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/services/authservice.dart';

class Home  extends StatefulWidget{
  @override
  _HomePageState createState() =>_HomePageState();

}

class _HomePageState  extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
            child: Text('Home Page')
        )
    );
  }

}
