import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'form.dart';

void main() {
  runApp(const MaterialApp(
    home: ResponsiveForm(),
  ));
}

class ResponsiveForm extends StatefulWidget {
  const ResponsiveForm({super.key});
  @override
  State<ResponsiveForm> createState() => _ResponsiveFormState();
}

class _ResponsiveFormState extends State<ResponsiveForm> {
// Add state variables for form fields
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Expanded(
                  child: buildForm(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
