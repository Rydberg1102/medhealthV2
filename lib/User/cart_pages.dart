import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medhealth/main_page.dart';
import 'package:medhealth/network/api/url_api.dart';
import 'package:medhealth/network/model/cart_model.dart';
import 'package:medhealth/network/model/pref_profile_model.dart';
import 'package:medhealth/User/success_checkout.dart';
import 'package:medhealth/widget/button_primary.dart';
import 'package:medhealth/widget/widget_ilustration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';

class CartPage extends StatefulWidget {
  final VoidCallback method;
  // CartPage(this.method);
  const CartPage({super.key, required this.method});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final price = NumberFormat("#,##0", "EN_US");
  String? userID;
  String? fullName;
  String? address;
  String? phone;
  int delivery = 0;
  // bool isLoading = true;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUser);
      fullName = sharedPreferences.getString(PrefProfile.name);
      address = sharedPreferences.getString(PrefProfile.address);
      phone = sharedPreferences.getString(PrefProfile.phone);
      print('fullName: $fullName, address: $address, phone: $phone');
      // isLoading = false;
    });
    getCart();
    cartTotalPrice();
  }

  List<CartModel> listCart = [];
  getCart() async {
    listCart.clear();
    var urlGetCart = Uri.parse(BASEURL.getProductCart + userID!);
    final response = await http.get(urlGetCart);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map item in data) {
          listCart.add(CartModel.fromJson(item));
        }
      });
    }
  }

  updateQuantity(String type, String model) async {
    var urlUpdateQuantity = Uri.parse(BASEURL.updateQuantityProductCart);
    final response = await http
        .post(urlUpdateQuantity, body: {"cartID": model, "type": type});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      print(message);
      setState(() {
        getPref();
        widget.method();
      });
    } else {
      print(message);
      setState(() {
        getPref();
      });
    }
  }

  checkout() async {
    var urlCheckout = Uri.parse(BASEURL.checkout);
    final response = await http.post(urlCheckout, body: {
      "idUser": userID,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SuccessCheckout()),
          (route) => false);
    } else {
      print(message);
    }
  }

  var sumPrice = "0";
  int totalPayment = 0;
  cartTotalPrice() async {
    var urlTotalPrice = Uri.parse(BASEURL.totalPriceCart + userID!);
    final response = await http.get(urlTotalPrice);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String? total = data['Total'];
      setState(() {
        sumPrice = total ?? "0";
        totalPayment = sumPrice == null ? 0 : int.parse(sumPrice) + delivery;
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: listCart.length == 0
          ? SizedBox()
          : Container(
              padding: EdgeInsets.all(24),
              height: 220,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xfffcfcfc),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Items",
                        style: regularTextStyle.copyWith(
                            fontSize: 16, color: greyBoldColor),
                      ),
                      Text(
                        "RM " + price.format(int.parse(sumPrice)),
                        style: boldTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery fee",
                        style: regularTextStyle.copyWith(
                            fontSize: 16, color: greyBoldColor),
                      ),
                      Text(
                        delivery == 0 ? "FREE" : delivery.toString(),
                        style: boldTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Payment",
                        style: regularTextStyle.copyWith(
                            fontSize: 16, color: greyBoldColor),
                      ),
                      Text(
                        "RM " + price.format(totalPayment),
                        style: boldTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ButtonPrimary(
                      onTap: () {
                        checkout();
                      },
                      text: "CHECKOUT NOW",
                    ),
                  )
                ],
              ),
            ),
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.only(bottom: 220),
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
                  "My Cart",
                  style: regularTextStyle.copyWith(fontSize: 25),
                ),
              ])),
          listCart.length == 0 || listCart.length == null
              ? Container(
                  padding: EdgeInsets.all(24),
                  margin: EdgeInsets.only(top: 30),
                  child: WidgetIlustration(
                    image: "assets/empty_cart_ilustration.png",
                    title: "Oops, There are no product in your cart",
                    subtitle1: "Your cart is still empty, browse the",
                    subtitle2: "attractive products from MEDHEALTH",
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width,
                      child: ButtonPrimary(
                        text: "SHOPPING NOW",
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPages()),
                              (route) => false);
                        },
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(24),
                  height: 166,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dellivery Destination",
                        style: regularTextStyle.copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name",
                            style: regularTextStyle.copyWith(
                                fontSize: 16, color: greyBoldColor),
                          ),
                          Text(
                            "$fullName",
                            style: boldTextStyle.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Address",
                            style: regularTextStyle.copyWith(
                                fontSize: 16, color: greyBoldColor),
                          ),
                          Text(
                            "$address",
                            style: boldTextStyle.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phone",
                            style: regularTextStyle.copyWith(
                                fontSize: 16, color: greyBoldColor),
                          ),
                          Text(
                            "$phone",
                            style: boldTextStyle.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ListView.builder(
              itemCount: listCart.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                final x = listCart[i];
                return Container(
                  padding: EdgeInsets.all(24),
                  color: whiteColor,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            x.image,
                            width: 115,
                            height: 100,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  x.name,
                                  style:
                                      regularTextStyle.copyWith(fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: greenColor,
                                        ),
                                        onPressed: () {
                                          updateQuantity("plus", x.idCart);
                                        }),
                                    Text(x.quantity),
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Color(0xfff0997a),
                                      ),
                                      onPressed: () {
                                        updateQuantity("minus", x.idCart);
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  "RM" + price.format(int.parse(x.price)),
                                  style: boldTextStyle.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider()
                    ],
                  ),
                );
              })
        ],
      )),
    );
  }
}
