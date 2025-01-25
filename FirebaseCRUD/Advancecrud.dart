import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyAdvanceCrud extends StatelessWidget {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final regNoController = TextEditingController();
  final subjectsController = TextEditingController();

  void _saveData(BuildContext context) async {
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        regNoController.text.isEmpty ||
        subjectsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fill all the Fields"),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance.collection("MyAdvanceCollection").add({
        "name": nameController.text,
        'age': ageController.text,
        'regno': regNoController.text,
        'subjects': subjectsController.text
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Submitted Successfully")),
      );

      // Clear the text fields after successful submission
      nameController.clear();
      ageController.clear();
      regNoController.clear();
      subjectsController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to Submit")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(hintText: "Age"),
            ),
            TextField(
              controller: regNoController,
              decoration: InputDecoration(hintText: "Reg. No"),
            ),
            TextField(
              controller: subjectsController,
              decoration: InputDecoration(hintText: "Subjects"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveData(context);
              },
              child: Text("Submit Form"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(),
                  ),
                );
              },
              child: Text("Show Data"),
            ),
          ],
        ),
      ),
    );
  }
}


class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final searchByName = TextEditingController();

  void _deleteMe(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("MyAdvanceCollection")
          .doc(id)
          .delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Deleted Successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to Delete")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firestore Data")),
      body: Center(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchByName,
                decoration: InputDecoration(hintText: "Search by Name"),
                onChanged: (value) {
                  setState(() {
                    // Triggers a rebuild to show the updated search results
                  });
                },
              ),
            ),
            // StreamBuilder for Firestore Data
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: searchByName.text.isEmpty
                    ? FirebaseFirestore.instance
                        .collection("MyAdvanceCollection")
                        .snapshots() // Show all documents if search is empty
                    : FirebaseFirestore.instance
                        .collection("MyAdvanceCollection")
                        .where('name', isGreaterThanOrEqualTo: searchByName.text) // Filter by name starting with input
                        .where('name', isLessThanOrEqualTo: searchByName.text + '\uf8ff') // Case-insensitive search using special character
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading spinner while waiting for data
                  }
                  if (snapshot.hasError) {
                    return Text("Error loading data"); // Display error message
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No data found"); // Handle empty collection
                  }

                  final documents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final item = documents[index];
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ${item['name'] ?? ''}"),
                            Text("Age: ${item['age'] ?? ''}"),
                            Text("Reg No: ${item['regno'] ?? ''}"),
                            Text("Subjects: ${item['subjects'] ?? ''}"),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteMe(context, item.id);
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateScreen(
                                      id: item.id,
                                      documents: item.data() as Map<String, dynamic>,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.update),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class UpdateScreen extends StatelessWidget {
  final String id;
  final Map<String, dynamic> documents;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final regNoController = TextEditingController();
  final subjectsController = TextEditingController();

  UpdateScreen({required this.id, required this.documents}) {
    nameController.text = documents['name'];
    ageController.text = documents['age'];
    regNoController.text = documents['regno'];
    subjectsController.text = documents['subjects'];
  }

  void submitUpdated(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("MyAdvanceCollection")
          .doc(id)
          .update({
        "name": nameController.text,
        'age': ageController.text,
        'regno': regNoController.text,
        'subjects': subjectsController.text
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Updated Successfully")));
      Navigator.pop(context); // Go back after updating
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to Update")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ageController,
              decoration: InputDecoration(hintText: "Age"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: regNoController,
              decoration: InputDecoration(hintText: "Reg. No"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: subjectsController,
              decoration: InputDecoration(hintText: "Subjects"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                submitUpdated(context);
              },
              child: Text("Update Data"),
            ),
          ],
        ),
      ),
    );
  }
}
