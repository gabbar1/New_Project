
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/services/authservice.dart';

class MyLotteries  extends StatefulWidget{
  @override
  _MyLotteriesPageState createState() =>_MyLotteriesPageState();

}

class _MyLotteriesPageState  extends State<MyLotteries>{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
            child: Text('My Lotteries')
        )
    );
  }

}
