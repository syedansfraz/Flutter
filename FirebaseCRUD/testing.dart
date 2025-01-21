import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TabBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lab Assignment 2'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add), text: 'Insert Product'),
              Tab(icon: Icon(Icons.list), text: 'Show Products'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InsertProduct(),
            ShowDataTable(),
          ],
        ),
      ),
    );
  }
}

// Insert Product Screen

class InsertProduct extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  void _saveProduct(BuildContext context) async {
    if (_idController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _specController.text.isEmpty ||
        _imageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    if (int.tryParse(_idController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID must be a valid number!')),
      );
      return;
    }

    int id = int.parse(_idController.text);

    try {
      QuerySnapshot existingProducts = await FirebaseFirestore.instance
          .collection('MyFlutterrr')
          .where('id', isEqualTo: id)
          .get();

      if (existingProducts.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product ID already exists! Please use a unique ID.')),
        );
        return;
      }

      double price = double.parse(_priceController.text);

      CollectionReference products =
          FirebaseFirestore.instance.collection('MyFlutterrr');

      await products.add({
        'id': id,
        'name': _nameController.text,
        'spec': _specController.text,
        'price': price,
        'image': _imageController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product Saved Successfully')),
      );
    } catch (e) {
      debugPrint('Error saving product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Save Product')),
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
            controller: _idController,
            decoration: InputDecoration(labelText: 'Product ID'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: _specController,
            decoration: InputDecoration(labelText: 'Product Specifications'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _imageController,
            decoration: InputDecoration(labelText: 'Product Image URL'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _saveProduct(context);
            },
            child: Text('Save Product'),
          ),
        ],
      ),
    );
  }
}

// Show Data Table Screen

class ShowDataTable extends StatelessWidget {
  void _deleteProduct(String docId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('MyFlutterrr')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product Deleted Successfully')),
      );
    } catch (e) {
      debugPrint('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Delete Product')),
      );
    }
  }

  void _navigateToUpdateScreen(
      BuildContext context, String docId, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductScreen(
          docId: docId,
          data: data,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('MyFlutterrr').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) { 
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<DataRow> rows = snapshot.data!.docs.map((doc) {
          return DataRow(
            cells: [
              DataCell(Text(doc['id'].toString())),
              DataCell(Text(doc['name'] ?? 'null')),
              DataCell(Text(doc['spec'] ?? 'null')),
              DataCell(Text(doc['price'].toString())),
              DataCell(Text(doc['image'] ?? 'null')),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(doc.id, context),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _navigateToUpdateScreen(
                          context, doc.id, doc.data() as Map<String, dynamic>),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Specifications')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Actions')),
            ],
            rows: rows,
          ),
        );
      },
    );
  }
}

// Update Product Screen

class UpdateProductScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  UpdateProductScreen({required this.docId, required this.data});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _specController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.data['id'].toString());
    _nameController = TextEditingController(text: widget.data['name']);
    _specController = TextEditingController(text: widget.data['spec']);
    _priceController = TextEditingController(text: widget.data['price'].toString());
    _imageController = TextEditingController(text: widget.data['image']);
  }

  void _updateProduct(BuildContext context) async {
    if (_idController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _specController.text.isEmpty ||
        _imageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    if (int.tryParse(_idController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID must be a valid number!')),
      );
      return;
    }

    int id = int.parse(_idController.text);

    try {
      QuerySnapshot existingProducts = await FirebaseFirestore.instance
          .collection('MyFlutterrr')
          .where('id', isEqualTo: id)
          .get();

      bool isIdConflict =
          existingProducts.docs.any((doc) => doc.id != widget.docId);

      if (isIdConflict) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product ID already exists! Please use a unique ID.')),
        );
        return;
      }

      double price = double.parse(_priceController.text);

      await FirebaseFirestore.instance
          .collection('MyFlutterrr')
          .doc(widget.docId)
          .update({
        'id': id,
        'name': _nameController.text,
        'spec': _specController.text,
        'price': price,
        'image': _imageController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product Updated Successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error updating product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Update Product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'Product ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _specController,
              decoration: InputDecoration(labelText: 'Product Specifications'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'Product Image URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateProduct(context);
              },
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
