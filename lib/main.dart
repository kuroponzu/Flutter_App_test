import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(new MyApp());

FirebaseUser firebaseUser;
class MyApp extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
     return MaterialApp(
       title: "FlutterDemo",
       routes: <String, WidgetBuilder>{
         '/': (_) => new Splash(),
         '/list': (_) => new _List(),
       },
     );
  }
}

class Splash extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    _getUser().then((user){
      Navigator.pushReplacementNamed(context, "/list");
    });
    return Scaffold(
      appBar: AppBar(
          title: const Text('かしかりメモ'),
      ),
      body: Center(
        child: new Text("スプラッシュ画面"),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  InputForm(this.docs);
  final DocumentSnapshot docs;

  @override
  _MyInputFormState createState() => new _MyInputFormState();
}
class _formData {
  String lendorrent;
  String user;
  String loan;
  DateTime date;
}

class _MyInputFormState extends State<InputForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _formData _data = new _formData();
  String lendorrent = "rent";
  bool deleteFlg;
  DateTime date = new DateTime.now();
  var change_Flg = 0;
  var lendorrent_Flg = 0;

  void _setLendorRent(String value){
    setState(() {
      lendorrent = value;
    });
  }

  Future <Null> _selectTime(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020)
    );

    if(picked != null && picked != date){
      setState(() {
        date = picked;
        change_Flg = 1;
        print(picked);
        print(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _mainReference;
    if (this.widget.docs != null) {
      if(lendorrent_Flg == 0 && widget.docs['lendorrent'].toString() == "lend"){
        lendorrent = "lend";
        lendorrent_Flg = 1;
      }
      _data.user = widget.docs['name'];
      _data.loan = widget.docs['loan'];
      print(date);
      if(change_Flg == 0) {
        date = widget.docs['date'];
      }
      _mainReference = Firestore.instance.collection('users').document(firebaseUser.uid).collection("promise").document(widget.docs.documentID);
      deleteFlg = true;
    } else {
      _data.lendorrent = "";
      _data.user = "";
      _data.loan = "";
      _mainReference = Firestore.instance.collection('users').document(firebaseUser.uid).collection("promise").document();
      deleteFlg = false;
    }

   return new Scaffold(
        appBar: AppBar(
          title: const Text('かしかりめも'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _data.lendorrent = lendorrent;
                _data.date = date;
                if (this._formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _mainReference.setData(
                      { 'lendorrent':_data.lendorrent ,'name': _data.user,
                        'loan': _data.loan,'date':_data.date});
                  Navigator.pop(context);
                  print('User: ${_data.user}');
                  print('Loan: ${_data.loan}');
                  print('lendorrent:${_data.lendorrent}');
                  print('date:${_data.date}');
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),

              onPressed: !deleteFlg? null:() {
                  print("Delete");
                  _mainReference.delete();
                  Navigator.pop(context);
              },
            )
          ],
        ),
        body: new SafeArea(
          child:
            new Form(
                key: this._formKey,
                child: new ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: <Widget>[
                       RadioListTile(
                        value: "rent",
                        groupValue: lendorrent,
                        title: new Text("借りた"),
//                          selected:true,
                        onChanged: (String value){
                          _setLendorRent(value);
                          print("押したよ");
                          print(value);
                        },
                      ),

                      RadioListTile(
                        value: "lend",
                        groupValue: lendorrent,
                        title: new Text("貸した"),
                        onChanged: (String value) {
                          _setLendorRent(value);
                        }
                      ),
                      new TextFormField(
                        //controller: _myController,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: '相手の名前',
                          labelText: 'Name',

                        ),
                        onSaved: (String value) {
                          this._data.user = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '名前は必須入力項目です';
                          }
                        },
                        initialValue: _data.user,
                      ),
                      new TextFormField(
                        //controller: _myController2,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.business_center),
                          hintText: '借りたもの、貸したもの',
                          labelText: 'loan',
                        ),
                        onSaved: (String value) {
                          this._data.loan = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '借りたもの、貸したものは必須入力項目です';
                          }
                        },
                        initialValue: _data.loan,
                      ),
                       new Text("締め切り日：${date.toString()}"),
                       new RaisedButton(
                           child: new Text("締め切り日変更"),
                           onPressed: (){_selectTime(context);}
                       ),


                      ],
                ),
            ),
        ),
    );

  }
}

class _List extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("いちらん"),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                print("login");
                showBasicDialog(context);
              },
            )
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('users').document(firebaseUser.uid).collection("promise").snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  padding: const EdgeInsets.only(top: 10.0),
                  //itemExtent: 25.0,
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data.documents[index]),
                );
              }
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.check),
        onPressed: () {
          print("新規作成");
          Navigator.push(
            context,
            MaterialPageRoute(
                settings: const RouteSettings(name: "/new"),
                builder: (BuildContext context) => new InputForm(null)
            ),
          );
        },
      ),
    );
  }
}
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return new Card(
      child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.android),
              title: Text(document['name']),
              subtitle: Text(document['loan']),
            ),
            new ButtonTheme.bar(
                child: new ButtonBar(
                  children: <Widget>[
                    new FlatButton(
                      child: const Text("へんしゅう"),
                      onPressed: () {
                        print(document.documentID);
                        print(document['name']);
                        print("へんしゅうだよ");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: const RouteSettings(name: "/overwrite"),
                              builder: (BuildContext context) =>
                              new InputForm(document)
                          ),
                        );
                      },
                    ),
                  ],
                )
            ),
          ]
      ),
    );
  }

  void showBasicDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    String email, password;
    if(firebaseUser.isAnonymous) {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
        new AlertDialog(
          title: new Text("ログイン/登録ダイアログ"),
          content: new Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.mail),
                    labelText: 'Email',
                  ),
                  onSaved: (String value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Emailは必須入力項目です';
                    }
                  },

                ),
                new TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.vpn_key),
                    labelText: 'Password',
                  ),
                  onSaved: (String value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Passwordは必須入力項目です';
                    }
                    if(value.length<6){
                      return 'Passwordは6桁以上です';
                    }
                  },
                ),

              ],
            ),
          ),


          // ボタンの配置
          actions: <Widget>[
            new FlatButton(
                child: const Text('キャンセル'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('登録'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _createUser(email, password)
                        .then((FirebaseUser user) => Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false))
                        .catchError((e) {
                          Fluttertoast.showToast(msg: "Firebaseの登録に失敗しました。");
                    });
                  }
                }),
            new FlatButton(
                child: const Text('ログイン'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _signIn(email, password)
                        .then((FirebaseUser user) => Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false))
                        .catchError((e) {
                          Fluttertoast.showToast(msg: "Firebaseのログインに失敗しました。");
                    });
                  }
                })
          ],
        ),
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) =>
        new AlertDialog(
          title: new Text("確認ダイアログ"),
          content: new Text((firebaseUser.isAnonymous?"匿名ユーザー":firebaseUser.email) + " でログインしています。"),

          actions: <Widget>[
            new FlatButton(
                child: const Text('キャンセル'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('ログアウト'),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
                }),
          ],
        ),
      );
    }
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<FirebaseUser> _signIn(String email, String password) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    print("User id is ${user.uid}");
    return user;
  }

  Future<FirebaseUser> _createUser(String email, String password) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print("User id is ${user.uid}");
    return user;
  }

  Future<FirebaseUser> _getUser() async {
    final FirebaseUser user = await _auth.currentUser();
    if(user != null) {
      firebaseUser = user;
    }else{
      await _auth.signInAnonymously();
      firebaseUser = await _auth.currentUser();
    }
  }
