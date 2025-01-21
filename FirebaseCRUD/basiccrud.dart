import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyCrud extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Information cell"),
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.add),
              ),
              Tab(
                icon: Icon(Icons.list),
              )
            ]),
          ),
          body: TabBarView(
            children: [
              insertData(),
              seeData(),
            ],
          ),
        ));
  }
}

class insertData extends StatelessWidget {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  void _saveInfoMethod(BuildContext context) async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fill all the fields"),
        ),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance.collection("MyNewCollection").add({
        "name": _nameController.text,
        "age": _ageController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Info Saved Successfully"),
        ),
      );
      _nameController.text = "";
      _ageController.text = "";
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to Save Info"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Your Good Name'),
          ),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'Your Age'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveInfoMethod(context);
            },
            child: Text("Save Info"),
          ),
        ],
      ),
    );
  }
}

class seeData extends StatelessWidget {
  void _deleteStud(String id, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('MyNewCollection')
          .doc(id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student Deleted Successfully')),
      );
    } catch (e) {
      debugPrint('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Delete Info')),
      );
    }
  }

  void _NavigateUpdateScreen(String id, context, Map<String, dynamic> data) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UpdateScreen(id, data)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("MyNewCollection")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<DataRow> rowss = snapshot.data!.docs.map((doc) {
            return DataRow(
              cells: [
                DataCell(Text(doc['name'] ?? 'null')),
                DataCell(Text(doc['age'] ?? 'null')),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteStud(doc.id, context),
                    ),
                    IconButton(
                        onPressed: () {
                          _NavigateUpdateScreen(doc.id, context,
                              doc.data() as Map<String, dynamic>);
                        },
                        icon: Icon(Icons.update)),
                  ],
                ))
              ],
            );
          }).toList();
          return SingleChildScrollView(
              child: DataTable(
            columns: [
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Age")),
              DataColumn(label: Text("Actions")),
            ],
            rows: rowss,
          ));
        });
  }
}

class UpdateScreen extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;
  final _nameController2 = TextEditingController();
  final _ageController2 = TextEditingController();
  UpdateScreen(this.docId, this.data) {
    _nameController2.text = data['name'] ?? '';
    _ageController2.text = data['age'] ?? '';
  }

  void _updateInfo(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("MyNewCollection")
          .doc(docId)
          .update({"name": _nameController2.text, "age": _ageController2.text});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Info Updated Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Info Failed to Update')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Update Screen"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController2,
                  decoration: InputDecoration(labelText: 'Your Good Name'),
                ),
                TextField(
                  controller: _ageController2,
                  decoration: InputDecoration(labelText: 'Your Age'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateInfo(context);
                  },
                  child: Text("Save Info"),
                ),
              ],
            ),
          )),
    );
  }
}
