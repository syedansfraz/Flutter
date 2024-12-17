import 'package:flutter/material.dart';

class DynamicListViewExample extends StatelessWidget {
  final List<String> names = ['John', 'Jane', 'Alice', 'Bob', 'Charlie'];

  const DynamicListViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: names.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(names[index][0]),
          ),
          title: Text(names[index]),
          subtitle: Text('User ${index + 1}'),
          trailing: const Icon(Icons.wifi_tethering_sharp),
        );
      },
      separatorBuilder: (context, index) {
        // Add a divider or custom widget
        return const Divider(
          color: Colors.grey,
          thickness: 1,
        );
      },
    );
  }
}