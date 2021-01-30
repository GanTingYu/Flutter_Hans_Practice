import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //to convert data into list or map
import 'sqlite_Helper.dart';

void main()=>runApp(MaterialApp(
  home: HomePage(),
));


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url ='http://jsonplaceholder.typicode.com/posts';
  final sqlHelp = Sqlite_Helper();

  getAllPost()async{
    await sqlHelp.open();
    return await sqlHelp.queryAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.http),
        onPressed: ()async{
          await sqlHelp.open();
          var res = await http.get(url);
          List l = jsonDecode(res.body);
          l.forEach((e)async => await sqlHelp.insert(e));
          setState(() {

          });
        },
      ),
      appBar: AppBar(
        title: Text("sqlite in Flutter"),
      ),

      body: FutureBuilder(
        future: getAllPost(),
        builder: (context, snap){
        if(snap.hasData){
          List l = snap.data;
          return ListView.builder(
                itemCount: l.length,
                itemBuilder: (context,idx){
                return InkWell(
                  onTap: ()async{
                    await sqlHelp.delete(l[idx]['id']);
                    setState(() {

                    });
                  },
                  child:ListTile(title:Text(l[idx]['title']),),
                );

          });
        }
        return Container();
      },

      ),
    );
  }
}
