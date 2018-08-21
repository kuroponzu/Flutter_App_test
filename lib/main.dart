import 'package:flutter/material.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "FlutterDemo",
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text("FlutterDemo"),
//        ),
        home: new _List(),
            //textSection,
      );
  }
}

class InputForm extends StatefulWidget {
  InputForm({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyInputFormState createState() => new _MyInputFormState();
}

class _MyInputFormState extends State<InputForm> {
//  final _formkey = GlobalKey<FormState>();
//  @override
 Widget build(BuildContext context) {
   final _myController = TextEditingController();
   final _myController2 = TextEditingController();

   Widget titleSection = Scaffold(
       appBar: AppBar(
         title: const Text('かしかりめも'),
         actions: <Widget>[
           // action button
           //https://docs.flutter.io/flutter/material/Icons-class.html
           IconButton(
             icon: Icon(Icons.save),
             onPressed: () {
               print(_myController.text);
               Navigator.push(
                 context,
                 MaterialPageRoute(
                     settings: const RouteSettings(name: "/home"),
                     //builder: (context) => new _List(_myController,_myController2)
                     builder: (context) => new _List()
               ),
               );
             },
           ),
           IconButton(
             icon: Icon(Icons.delete),
             onPressed: () {
               print("Delete");
               _myController.text = "";
             },
           )
         ],
       ),
       body: new SafeArea(
           child: new Form(
               child: new ListView(
                 padding: const EdgeInsets.all(20.0),
                   children: <Widget>[
//               new Flexible(
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       child: Text("相手:"),
//                     ),
//                   ],)
//             ),
//             new Flexible(
//               fit: FlexFit.loose,
                     new TextFormField(
                       controller: _myController,
                       decoration: const InputDecoration(
                         icon: const Icon(Icons.person),
                         hintText: '名前',
                         labelText: 'Name',
                       ),
                     ),
                   ]
               ))
       )
   );
   return titleSection;
 }
}

class _List extends StatelessWidget {

//  final param1;
//  final param2;
//
//  _List(this.param1, this.param2);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("いちらん"),
      ),
      body: new Card(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.android),
                title: Text("テストのためにpram1無くしました"),
                subtitle: Text("テストのためにpram2無くしました"),
              ),
              new ButtonTheme.bar(
                  child: new ButtonBar(
                    children: <Widget>[
                      new FlatButton(
                        child: const Text("へんしゅう"),
                        onPressed: () {
                          print("へんしゅうだよ");
                        },
                      ),
                    ],
                  )
              ),
              const ListTile(
                leading: const Icon(Icons.android),
                title: const Text("test"),
                subtitle: const Text("tenst"),
              ),
              new ButtonTheme.bar(
                  child: new ButtonBar(
                    children: <Widget>[
                      new FlatButton(
                        child: const Text('へんしゅうその２'),
                        onPressed: () {
                          print("へんしゅうだよその２");
                        },
                      ),
                    ],
                  )
              )
            ],
          )
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.check),
        onPressed: () {
          print("新規作成");
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: "/new"),
              builder: (BuildContext context) => new InputForm()
            ),
          );
        },
      ),
    );
  }
}