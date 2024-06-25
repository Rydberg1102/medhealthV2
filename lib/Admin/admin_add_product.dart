import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medhealth/Admin/admin_main_page.dart';
import 'package:medhealth/network/api/url_api.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../theme.dart';
import '../widget/button_primary.dart';

class AdminAddProduct extends StatefulWidget {
  const AdminAddProduct({super.key});

  @override
  State<AdminAddProduct> createState() => _AdminAddProductState();
}

class _AdminAddProductState extends State<AdminAddProduct> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? description;
  String? image;
  String? price;
  int? idCategory;

  final Map<int, String> categories = {
    1: 'Antibiotics',
    2: 'Vitamins',
    3: 'Digestive',
    4: 'Skin',
    5: 'Cough and Flu',
    6: 'Fever',
    7: 'Antiseptics',
    8: 'Covid-19 Info',
  };

  Future<void> submitForms() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var urlAddProduct = Uri.parse(BASEURL.apiAdminAddProduct);
      final response = await http.post(urlAddProduct, body: {
        'name': name,
        'description': description,
        'image': image,
        'price': price,
        'id_category': idCategory.toString(),
      });
      final data = jsonDecode(response.body);
      int value = data['value'];
      String message = data['message'];
      if (value == 1) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Information"),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminMainPages()),
                        (route) => false);
                  },
                  child: Text("Ok"))
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Information"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
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
                    "Add Product",
                    style: regularTextStyle.copyWith(fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        onSaved: (value) => name = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the product name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        onSaved: (value) => description = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the product description';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => price = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the product price';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(labelText: 'Category'),
                        value: idCategory,
                        onChanged: (int? newValue) {
                          setState(() {
                            idCategory = newValue;
                          });
                        },
                        items: categories.entries
                            .map<DropdownMenuItem<int>>((entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                        onSaved: (value) => idCategory = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        onSaved: (value) => image = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the image URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: submitForms,
                      //   child: Text(
                      //     'Add Product',
                      //     style: TextStyle(),
                      //   ),
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ButtonPrimary(
                            text: "ADD PRODUCT",
                            onTap: () {
                              submitForms();
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
