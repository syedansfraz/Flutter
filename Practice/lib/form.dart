import 'package:flutter/material.dart';

Widget buildForm(BuildContext context) {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(20.0), // Padding around the form
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0), // Spacing after Name field
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Name",
            ),
            keyboardType: TextInputType.name,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0), // Spacing after Email field
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0), // Spacing after Phone field
          child: TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: "Phone No.",
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0), // Spacing after Address field
          child: TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: "Address",
            ),
            keyboardType: TextInputType.streetAddress,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0), // Spacing after Address field
          child:
        ElevatedButton( 
          onPressed: () => submissionMessage(context),
          child: const Text("Submit"),
        ),),
      ],
    ),
  );
}

void submissionMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Form is Submitted!"),
      backgroundColor: Colors.amber,
    ),
  );
}
