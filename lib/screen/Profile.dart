
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:helloworld/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Profile extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();

}

class MapScreenState extends State<Profile>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String uid = '';
  String name;
  String email;
  String pin;
  String state;
  String uname;
  String urlpath;
  String imageurl;
  getUid() {}
  @override
  void initState() {
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.phoneNumber;
        val.photoUrl;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
   imageurl = url.toString();

  }

  final DBRef = FirebaseDatabase.instance.reference();

  sendData(){
    DBRef.child("Users").child(uid).set({
      'Name':name,
      'Email':email,
      'pincode':pin,
      'state':state
    });
  }

 FatchData(){
   var db=FirebaseDatabase.instance.reference().child("User").child(uid);
   db.once().then((DataSnapshot snapshot){
     Map<dynamic, dynamic> values=snapshot.value;
     uname = values["name"];
   });
 }
  File _image;
  File _image1;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 2,);

    setState(() {
      _image = File(pickedFile.path);
    });
  }



  Future uploadPic(BuildContext context) async{
    String filename = basename(_image.path);
    StorageReference firebaseStorage = FirebaseStorage.instance.ref().child(uid);
    StorageUploadTask uploadTask =firebaseStorage.child(uid).putFile(_image);
    StorageTaskSnapshot taskSnapshot  = await uploadTask.onComplete;
    var ref = FirebaseStorage.instance.ref().child(uid).child(uid);
// no need of the file extension, the name will do fine.
    //var url = await ref.getDownloadURL();
 //   var url = Uri.parse(await ref.getDownloadURL() as String);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      print("Uploaded");

      print(downloadUrl);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Pic"),));
    });



  }
  @override
  Widget build(BuildContext context) {




    return new Scaffold(
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _profile()

                              ],
                            ),

                            Padding(
                                padding: EdgeInsets.only(top: 160,left:160),
                                child: RaisedButton(
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),onPressed: (){
                                  uploadPic(context);
                                },
                                )
                            )

                               /* new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),

                                    ),
                                  ],
                                )),*/
                          ]),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Personal Information',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),

                              ),

                            ],
                          ),
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _status ? _getEditIcon() : new Container(),
                            ],
                          )
                        ],
                      )),
                  _userdetails(),
                  new Container(
                    child: RaisedButton(
                      child: Center(
                          child: Text('SignOut')
                      ),elevation: 2.0,
                      color: Colors.yellow[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      onPressed: (){
                        AuthService().signOut();
                      },
                    ),

                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _userdetails(){
    if( _status == true) {
      return Container(
        color: Color(0xffFFFFFF),
        child: Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 4.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flexible(

                          child: new Text("Name", style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),)
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          new StreamBuilder<Event>(
                            stream: FirebaseDatabase.instance
                            .reference()
                            .child('Users')
                            .child(uid).onValue,
                              builder: (BuildContext context, AsyncSnapshot<Event> event){
                              if(!event.hasData)
                                return new Center (child:new Text("Name"));
                              Map<dynamic,dynamic> data = event.data.snapshot.value;
                              return Column (children: <Widget>[
                                new Text('${data['Name']}',
                                    style: new TextStyle(fontSize: 20.0)),
                              ]);
                              }
                          )
                         /* new Text(uname,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),*/
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'Email ID',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 2.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new StreamBuilder<Event>(
                          stream: FirebaseDatabase.instance
                              .reference()
                              .child('Users')
                              .child(uid).onValue,
                          builder: (BuildContext context, AsyncSnapshot<Event> event){
                            if(!event.hasData)
                              return new Center (child:new Text("Name"));
                            Map<dynamic,dynamic> data = event.data.snapshot.value;
                            return Column (children: <Widget>[
                              new Text('${data['Email']}',
                                  style: new TextStyle(fontSize: 20.0)),
                            ]);
                          }
                      )
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'Mobile',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 2.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flexible(
                        child: new Text(uid),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'Pin Code',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 2.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new StreamBuilder<Event>(
                          stream: FirebaseDatabase.instance
                              .reference()
                              .child('Users')
                              .child(uid).onValue,
                          builder: (BuildContext context, AsyncSnapshot<Event> event){
                            if(!event.hasData)
                              return new Center (child:new Text("Pincode"));
                            Map<dynamic,dynamic> data = event.data.snapshot.value;
                            return Column (children: <Widget>[
                              new Text('${data['pincode']}',
                                  style: new TextStyle(fontSize: 20.0)),
                            ]);
                          }
                      )
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'State',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 2.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new StreamBuilder<Event>(
                          stream: FirebaseDatabase.instance
                              .reference()
                              .child('Users')
                              .child(uid).onValue,
                          builder: (BuildContext context, AsyncSnapshot<Event> event){
                            if(!event.hasData)
                              return new Center (child:new Text("State"));
                            Map<dynamic,dynamic> data = event.data.snapshot.value;
                            return Column (children: <Widget>[
                              new Text('${data['state']}',
                                  style: new TextStyle(fontSize: 20.0)),
                            ]);
                          }
                      )
                    ],
                  )),


            ],
          ),
        ),
      );
    }
    else{
      return Container(
        child: Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text("Name",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 8.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flexible(

                        child: new TextField(
                          decoration: const InputDecoration(
                              hintText: "Enter Name"),
                          onChanged: (val){
                            this.name=val;
                          },
                          enabled: !_status,
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'Email ID',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 2.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          decoration: const InputDecoration(
                              hintText: "Enter Email ID"),
                          onChanged: (val){
                            this.email=val;
                          },
                          enabled: !_status,
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'Mobile',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 2.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flexible(
                        child: new Text(uid),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: new Text(
                            'Pin Code',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Container(
                          child: new Text(
                            'State',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 2.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: new TextField(
                            decoration: const InputDecoration(
                                hintText: "Enter Pin Code"),
                            onChanged: (val){
                              this.pin=val;
                            },
                            enabled: !_status,
                          ),
                        ),
                        flex: 2,
                      ),
                      Flexible(
                        child: new TextField(
                          decoration: const InputDecoration(
                              hintText: "Enter State"),
                          onChanged: (val){
                            this.state=val;
                          },
                          enabled: !_status,
                        ),
                        flex: 2,
                      ),
                    ],
                  )),
              !_status ? _getActionButtons() : new Container(),
            ],
          ),
        ),
      );
    }
  }

  Widget _profile(){
    return
        InkWell(
          child:  Align(
            alignment: Alignment.center,
            child:
            CircleAvatar(
                radius:100,
                backgroundColor: Color(0xff476cfb),
                child:ClipOval(
                    child:SizedBox(
                        width: 180.0,
                        height: 180.0,
                        child:  Image(
                            image:FirebaseImage('gs://helloflutter-bd2ed.appspot.com/'+uid+'/'+uid
                                , shouldCache: false, // The image should be cached (default: True)
                                maxSizeBytes: 30 * 10, // 3MB max file size (default: 2.5MB)
                                cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE)
                        )

                    )
                )
            ),
          ),
          onTap: (){
            getImage();
          },
        );

  }

  Widget _getActionButtons() {


    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        _status = true;
                      //  FocusScope.of(context).requestFocus(new FocusNode());
                        sendData();

                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                       // FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}