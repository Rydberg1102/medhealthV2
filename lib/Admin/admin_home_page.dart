import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:medhealth/Admin/admin_add_product.dart';
import 'package:medhealth/Admin/admin_detail_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User/cart_pages.dart';
import '../User/detail_product.dart';
import '../User/search_product.dart';
import '../network/api/url_api.dart';
import '../network/model/pref_profile_model.dart';
import '../network/model/product_model.dart';
import '../theme.dart';
import '../widget/card_category.dart';
import '../widget/card_product.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late int index;
  bool filter = false;
  List<CategoryWithProduct> listCategory = [];

  getCategory() async {
    listCategory.clear();
    var urlCategory = Uri.parse(BASEURL.categoryWithProduct);
    final response = await http.get(urlCategory);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map item in data) {
          listCategory
              .add(CategoryWithProduct.fromJson(item as Map<String, dynamic>));
        }
      });
      getProduct();
      totalCart();
    }
  }

  List<ProductModel> listProduct = [];
  getProduct() async {
    listProduct.clear();
    var urlProduct = Uri.parse(BASEURL.getProduct);
    final response = await http.get(urlProduct);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map product in data) {
          listProduct
              .add(ProductModel.fromJson(product as Map<String, dynamic>));
        }
      });
    }
  }

  String? userID;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUser);
    });
  }

  var totalCartt = "0";
  totalCart() async {
    var urlGetTotalCart = Uri.parse(BASEURL.getTotalCart + userID!);
    final response = await http.get(urlGetTotalCart);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['Total'];
      setState(() {
        totalCartt = total;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
      padding: EdgeInsets.fromLTRB(24, 30, 25, 30),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 155,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Find a medicine or\nvitamins with MEDHEALTH",
                  style: regularTextStyle.copyWith(
                      fontSize: 15, color: greyBoldColor),
                )
              ],
            ),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 90),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminAddProduct()));
                    },
                    icon: Icon(
                      Icons.add,
                      color: greenColor,
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartPage(
                                  method: () {
                                    totalCart();
                                  },
                                )));
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: greenColor,
                  ),
                ),
                totalCartt == "0"
                    ? SizedBox()
                    : Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: Text(
                            totalCartt,
                            style: regularTextStyle.copyWith(
                                color: whiteColor, fontSize: 12),
                          )),
                        ),
                      )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchProduct()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffe4faf0)),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xffb1d8b2),
                  ),
                  hintText: "Search medicine ...",
                  hintStyle:
                      regularTextStyle.copyWith(color: Color(0xffb0d8b2))),
            ),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          "Medicine & Vitamins by Category",
          style: regularTextStyle.copyWith(fontSize: 16),
        ),
        SizedBox(
          height: 14,
        ),
        GridView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: listCategory.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 10),
            itemBuilder: (context, i) {
              final x = listCategory[i];
              return InkWell(
                onTap: () {
                  setState(() {
                    index = i;
                    filter = true;
                    print("$index, $filter");
                  });
                },
                child: CardCategory(
                  imageCategory: x.image,
                  nameCategory: x.category,
                ),
              );
            }),
        SizedBox(
          height: 32,
        ),
        filter
            ? index == 7
                ? Text("Feature on Progress")
                : GridView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: listCategory[index].product.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16),
                    itemBuilder: (context, i) {
                      final y = listCategory[index].product[i];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AdminDetailProduct(productModel: y)));
                        },
                        child: CardProduct(
                          nameProduct: y.nameProduct,
                          imageProduct: y.imageProduct,
                          price: y.price,
                        ),
                      );
                    })
            : GridView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: listProduct.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16),
                itemBuilder: (context, i) {
                  final y = listProduct[i];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminDetailProduct(productModel: y)));
                    },
                    child: CardProduct(
                      imageProduct: y.imageProduct,
                      nameProduct: y.nameProduct,
                      price: y.price,
                    ),
                  );
                }),
      ],
    )));
  }
}
