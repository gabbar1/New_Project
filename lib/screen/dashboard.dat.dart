
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/screen/Home.dart';
import 'package:helloworld/screen/MyLotteries.dart';
import 'package:helloworld/screen/Profile.dart';
import 'package:helloworld/screen/Winners.dart';

class DashboardPage  extends StatefulWidget{
  @override
  _DashboardPageState createState() =>_DashboardPageState();

}


class _DashboardPageState extends State<DashboardPage> {
    int _CurrentIdex=0;

    Widget callPage(int currentIdex){
      switch(currentIdex){
        case 0 : return Home();
        case 1:return  MyLotteries();
        case 2:return  Winner();
        case 3:return  Profile();
          break;
        default: return Home();
      }
    }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.yellow[600],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.yellow[600],
        //rgba(255, 214, 0, 1)
        title: Center(child: const Text('Luck',
        style: TextStyle(
          fontSize: 32
        ),)
        ),

      ),
        body: callPage(_CurrentIdex),
        bottomNavigationBar: BottomNavigationBar(


          backgroundColor: Colors.yellow[600],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.black26,
          selectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          currentIndex: _CurrentIdex,
                    onTap: (value){
            _CurrentIdex=value;
            setState(() {

            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),
              title: Text('home'),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),
              title: Text('my lottery'),
              ),
            BottomNavigationBarItem(icon: Icon(Icons.list),
              title: Text('winners'),
                ),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle),
              title: Text('profile'),
                ),
          ],
        ),

    );
  }
}
