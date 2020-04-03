import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'source.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main(){
  runApp(
    new MaterialApp(
      home: FirstPage(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class FirstPage extends StatelessWidget {
  var _categoryNameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.black26,
        child: Center(
          child: ListView(
            children: <Widget>[Padding(padding: const EdgeInsets.all(30.0),),
              new Image.asset('images/photo-camera.png',width: 200.0,height: 200.0),
              new ListTile(
                title: new TextFormField(
                  controller: _categoryNameController,
                  decoration: new InputDecoration(
                    labelText: 'Enter name of category',
                    hintText: 'ex: dogs, cats, bike, etc...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0 , 25.0 , 10.0)
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(3.0)
              ),
              ListTile(
                title: new Material(
                color: Colors.lightBlue,
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(25.0),
                  child: new MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context){
                          return new SecondPage(category: _categoryNameController.text,);
                        })
                      );
                    },
                    child: Text(
                      'Search', style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  String category;
  SecondPage({this.category});
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Photo Finder', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: new FutureBuilder(
          future: getPics(widget.category),
          builder: (context,snapShot){
            Map data = snapShot.data;
            if(snapShot.hasError){
              return Text('Failed to get response from the server',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22.0
                ),
              );
            }else if(snapShot.hasData){
              return new Center(
                child: new ListView.builder(
                  itemCount: data.length,
                    itemBuilder: (context,index){
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: const EdgeInsets.all(5.0)),
                          new Container(
                            child: new InkWell(
                              onTap: (){},
                              child: new Image.network('${data['hits'][index]['largeImageURL']}'
                              ),
                            ),
                          )
                        ],
                      );
                  }
                ),
              );
            }else if(!snapShot.hasData){
              return new Center(child: CircularProgressIndicator(),);
            }
          }
      ),
    );
  }
}
Future<Map> getPics(String category) async{
  String url = 'https://pixabay.com/api/?key=$apiKey&q=$category&image_type=photo&pretty=true';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}
