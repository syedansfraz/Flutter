import 'package:flutter/material.dart';

class ListViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('John Doe'),
            subtitle: Text('Software Engineer'),
            trailing: Icon(Icons.call),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Jane Smith'),
            subtitle: Text('Product Manager'),
            trailing: Icon(Icons.email),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Alice Johnson'),
            subtitle: Text('Designer'),
            trailing: Icon(Icons.message),
          ),
        ],
      );
  }
}
