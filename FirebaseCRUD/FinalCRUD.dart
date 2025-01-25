import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyFinalCrud extends StatelessWidget{

final controller1=TextEditingController();
final controller2= TextEditingController();
final controller3=TextEditingController();

void _saveData(BuildContext context) async{

  if(controller1.text.isNotEmpty|| controller2.text.isNotEmpty|| controller3.text.isNotEmpty){
    try{
        await FirebaseFirestore.instance.collection("FinalCollection").add({
          'id':controller1.text,
          'name':controller2.text,
          'age':controller3.text});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success"),backgroundColor: Colors.blue));
        
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed"),backgroundColor: Colors.red));
    }
  }
}
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(child: 
      Column(
        children:[
          TextField(
            controller: controller1,
            decoration: InputDecoration(
              hintText: "Id",
            ),
          ),
          TextField(
            controller: controller2,
            decoration: InputDecoration(
              hintText: "Name",    
            ),
          ),
          TextField(
            controller: controller3,
            decoration: InputDecoration(
              hintText: "Age",
            ),
          ),ElevatedButton(onPressed: (){
              _saveData(context);
          }, child: Text("Submit")),
          ElevatedButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=> ShowDataPage()));

          }, child: Text("Show Data"))
        ]
      )
      )
    );
  }
}
//SecondPage
class ShowDataPage extends StatefulWidget{

  ShowDataPage({super.key});
  @override
  State<ShowDataPage> createState()=> _ShowDataPageState();
}

class _ShowDataPageState extends State<ShowDataPage> {

  void _deleteItem(BuildContext context,String id)async{
    try{
      await FirebaseFirestore.instance.collection("FinalCollection").doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success"),backgroundColor: Colors.blue));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Faield"),backgroundColor: Colors.red));

    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(child: 
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection("FinalCollection").snapshots(),
        builder: (context,snapshots){
          return ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder:(context,index){
              final item= snapshots.data!.docs[index];
              return ListTile(
                title: Row(
                  children: [
                    Text(item['id']),
                    Text(item['name']),
                    Text(item['age']),
                    IconButton(onPressed:(){
                      _deleteItem(context,item.id);
                    } , icon: Icon(Icons.delete)),
                    IconButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder:(context)=>UpdateScreen()));
            }, icon: Icon(Icons.update))
                  ],
                )
              );
            } );
        },
      )
      )
    );
  }
}
class UpdateScreen extends StatefulWidget{
  UpdateScreen({super.key});
  @override
  State<UpdateScreen> createState()=> _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen>{
 final searchController=TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search id',
          )
        )
      )
    );
  }
}