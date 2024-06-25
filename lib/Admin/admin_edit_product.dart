import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:medhealth/network/api/url_api.dart';
import 'package:medhealth/widget/button_primary.dart';

import '../theme.dart';

class AdminEditProduct extends StatefulWidget {
  final String idProduct;
  final String initialName;
  final String initialDescription;
  final String initialPrice;
  final String initialCategory;

  const AdminEditProduct({
    Key? key,
    required this.idProduct,
    required this.initialName,
    required this.initialDescription,
    required this.initialPrice,
    required this.initialCategory,
  }) : super(key: key);

  @override
  State<AdminEditProduct> createState() => _AdminEditProductState();
}

class _AdminEditProductState extends State<AdminEditProduct> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
    _priceController = TextEditingController(text: widget.initialPrice);
    _categoryController = TextEditingController(text: widget.initialCategory);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      var urlAdminEditProduct = Uri.parse(BASEURL.apiAdminEditProduct);
      final response = await http.post(urlAdminEditProduct, body: {
        'id_product': widget.idProduct,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'id_category': _categoryController.text,
      });

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        if (responseJson['value'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product updated successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to update product: ${responseJson['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to update product. Server error: ${response.statusCode}')),
        );
      }
    }
  }

  // Future<void> submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //     var urlAdminEditProduct = Uri.parse(BASEURL.apiAdminEditProduct);
  //     final response = await http.post(urlAdminEditProduct, body: {
  //       'id_product': widget.idProduct,
  //       'name': _nameController.text,
  //       'description': _descriptionController.text,
  //       'price': _priceController.text,
  //       'id_category': _categoryController.text,
  //     });

  //     if (response.statusCode == 200) {
  //       final responseJson = jsonDecode(response.body);
  //       if (responseJson['value'] == 1) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Product updated successfully')),
  //         );
  //         Navigator.pop(context);
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text(
  //                   'Failed to update product: ${responseJson['message']}')),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to update product. Server error.')),
  //       );
  //     }
  //   }
  // }

  // Future<void> submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //     final response = await http.post(
  //       Uri.parse('https://yourapiurl.com/apiAdminEditProduct'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'id_product': widget.idProduct,
  //         'name': _nameController.text,
  //         'description': _descriptionController.text,
  //         'price': _priceController.text,
  //         'id_category': _categoryController.text,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseJson = jsonDecode(response.body);
  //       if (responseJson['value'] == 1) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Product updated successfully')),
  //         );
  //         Navigator.pop(context);
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text(
  //                   'Failed to update product: ${responseJson['message']}')),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to update product. Server error.')),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SafeArea(
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              height: 70,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 32,
                      color: greenColor,
                    ),
                  ),
                  SizedBox(width: 30),
                  Text(
                    "Edit Product",
                    style: regularTextStyle.copyWith(fontSize: 25),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ButtonPrimary(
                        text: "UPDATE",
                        onTap: () {
                          print("Submit button pressed");
                          submitForm();
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
