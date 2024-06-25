import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medhealth/Admin/admin_edit_product.dart';
import 'package:medhealth/Admin/admin_main_page.dart';
import 'package:medhealth/network/model/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main_page.dart';
import '../network/api/url_api.dart';
import '../network/model/pref_profile_model.dart';
import '../theme.dart';
import '../widget/button_primary.dart';

class AdminDetailProduct extends StatefulWidget {
  final ProductModel productModel;
  const AdminDetailProduct({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<AdminDetailProduct> createState() => _AdminDetailProductState();
}

class _AdminDetailProductState extends State<AdminDetailProduct> {
  final priceFormat = NumberFormat("#,##0", "EN_US");

  String? userID;

  Future<void> getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUser);
    });
  }

  Future<void> deleteProduct() async {
    var urlDeleteProduct = Uri.parse(BASEURL
        .apiAdminDeleteProduct); // Ensure this URL matches your backend endpoint
    final response = await http.post(urlDeleteProduct, body: {
      "id_product": widget.productModel.idProduct,
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Information"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (value == 1) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AdminMainPages()),
                  (route) => false,
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: Text("Ok"),
          )
        ],
      ),
    );

    if (value == 1) {
      setState(() {});
    }
  }

  Future<void> addToCart() async {
    if (userID == null) return; // Handle case when userID is null

    var urlAddToCart = Uri.parse(BASEURL.addToCart);
    final response = await http.post(urlAddToCart, body: {
      "id_user": userID,
      "id_product": widget.productModel.idProduct,
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
              ));
      setState(() {});
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
                      child: Text("Ok"))
                ],
              ));
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                height: 70,
                child: Row(children: [
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
                    "Detail Product",
                    style: regularTextStyle.copyWith(fontSize: 25),
                  )
                ])),
            SizedBox(height: 24),
            Container(
              height: 200,
              color: whiteColor,
              child: Image.asset(widget.productModel.imageProduct),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productModel.nameProduct,
                    style: regularTextStyle.copyWith(fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.productModel.description,
                    style: regularTextStyle.copyWith(
                        fontSize: 14, color: greyBoldColor),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 64),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminEditProduct(
                                  idProduct: widget.productModel.idProduct,
                                  initialName: widget.productModel.nameProduct,
                                  initialDescription:
                                      widget.productModel.description,
                                  initialPrice: widget.productModel.price,
                                  initialCategory:
                                      widget.productModel.idCategory,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "EDIT",
                            style: boldTextStyle.copyWith(
                              fontSize: 15,
                              color: Colors.green,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            deleteProduct();
                          },
                          child: Text(
                            "DELETE",
                            style: boldTextStyle.copyWith(
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          )),
                      Spacer(),
                      Text(
                        "RM" +
                            priceFormat
                                .format(int.parse(widget.productModel.price)),
                        style: boldTextStyle.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ButtonPrimary(
                      onTap: () {
                        addToCart();
                      },
                      text: "ADD TO CART",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
