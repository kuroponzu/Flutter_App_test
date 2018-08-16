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
        home: new InputForm(),
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

                     new Container(
                         padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                         child: new RaisedButton(
                           child: const Text('Submit'),
                           onPressed: null,
                         )
                     )
                   ]
               ))
       )
   );
   return titleSection;
 }

}
