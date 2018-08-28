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
  InputForm(this.docs);
  final DocumentSnapshot docs;
  @override
  _MyInputFormState createState() => new _MyInputFormState();
}
class _formData {
  String user = '';
  String loan = '';
}
class _MyInputFormState extends State<InputForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _formData _data = new _formData();

//  @override
 Widget build(BuildContext context) {
   var _mainReference;
   if(this.widget.docs != null){
       //_myController.text = "強制的に変更";//widget.docs['name'];
     _data.user = widget.docs['name'];
     _data.loan = widget.docs['loan'];
     _mainReference = Firestore.instance.collection('promise').document(widget.docs.documentID);
   }else{
     _mainReference = Firestore.instance.collection('promise').document();
   }



   Widget titleSection = Scaffold(
       appBar: AppBar(
         title: const Text('かしかりめも'),
         actions: <Widget>[
           // action button
           IconButton(
             icon: Icon(Icons.save),
             onPressed: () {
               if (this._formKey.currentState.validate()) {
                 _formKey.currentState.save();
               }
               print('User: ${_data.user}');
               print('Loan: ${_data.loan}');

               _mainReference.setData({ 'name': _data.user, 'loan': _data.loan });
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
                       onSaved: (String value) {
                         this._data.user = value;
                       },
                       initialValue: _data.user,
                     ),
                     new TextFormField(
                       //controller: _myController2,
                       decoration: const InputDecoration(
                         icon: const Icon(Icons.person),
                         hintText: '借りたもの',
                         labelText: 'loan',
                       ),
                       onSaved: (String value) {
                         this._data.loan = value;
                       },
                       initialValue: _data.loan,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new StreamBuilder<QuerySnapshot>(
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
                                print(document.documentID);
                                print(document['name']);
                                print("へんしゅうだよ");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings: const RouteSettings(name: "/new"),
                                      builder: (BuildContext context) => new InputForm(document)
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
}