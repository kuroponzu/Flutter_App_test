import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "FlutterDemo",
      home: _List(),
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

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

 // var _myController = TextEditingController();
 // var _myController2 = TextEditingController();
  var name;
  var loan;
  

//  @override
 Widget build(BuildContext context) {


   final _mainReference = Firestore.instance.collection('promise').document();  // 1
   Widget titleSection = Scaffold(
       appBar: AppBar(
         title: const Text('かしかりめも'),
         actions: <Widget>[
           // action button
           IconButton(
             icon: Icon(Icons.save),
             onPressed: () {
               _formKey.currentState.save();
               _mainReference.setData({ 'name': name.toString(), 'loan': loan.toString()});
//               _myController.dispose();
//               _myController2.dispose();
               print(name);
               print(loan);
               Navigator.push(
                   context,
                   MaterialPageRoute(
                   settings: const RouteSettings(name: "/home"),
                       builder: (context) => new _List()
                   ),
               );
               }
               ),
           IconButton(
             icon: Icon(Icons.delete),
             onPressed: () {
               _formKey.currentState.save();
               print("Delete");
               print(name);
               print(loan);
               //_myController.text = "";
             },
           )
         ],
       ),
       body: new SafeArea(
           child: new Form(
               key: this._formKey,
               child: new ListView(
                 padding: const EdgeInsets.all(20.0),
                   children: <Widget>[
                     new TextFormField(
                       //controller: _myController,
                       decoration: const InputDecoration(
                         icon: const Icon(Icons.person),
                         hintText: '名前',
                         labelText: 'Name',
                       ),
                       onSaved: (String name){
                         this.name = name;
                       },
                     ),
                     new TextFormField(
                       validator: (value){},
                       //controller: _myController2,
                       decoration: const InputDecoration(
                         icon: const Icon(Icons.person),
                         hintText: '借りたもの',
                         labelText: 'loan',
                       ),
                       onSaved: (String loan){
                         this.loan = loan;
                       },
                     ),
                   ]
               ))
       )
   );
   return titleSection;
 }
}

class _List extends StatelessWidget {

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("いちらん"),
      ),
      body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('promise').snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
            //print(snapshot);
            //print(snapshot.hasData);
            //print(snapshot.error);
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
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.check),
        onPressed: () {
          print("新規作成");
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: "/new"),
              builder: (BuildContext context) =>  InputForm(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
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
                                print("へんしゅうだよ");
                              },
                            ),
                          ],
                        )
                    ),
                  ]
          ),
    );
  }
}