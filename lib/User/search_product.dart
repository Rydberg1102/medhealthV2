import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:medhealth/network/model/product_model.dart';
import 'package:medhealth/theme.dart';
import 'package:http/http.dart' as http;
import 'package:medhealth/widget/button_primary.dart';
import 'package:medhealth/widget/widget_ilustration_page.dart';
import '../network/api/url_api.dart';
import '../widget/card_product.dart';
import 'detail_product.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController searchController = TextEditingController();
  List<ProductModel> listProduct = [];
  List<ProductModel> listSearchProduct = [];
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

  List<ProductModel> getRecommendations(String idCategory) {
    return listProduct
        .where((product) => product.idCategory == idCategory)
        .toList();
  }

  searchProduct(String text) {
    listSearchProduct.clear();
    if (text.isEmpty) {
      setState(() {});
    } else {
      listProduct.forEach((element) {
        if (element.nameProduct.toLowerCase().contains(text)) {
          listSearchProduct.add(element);
        }
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 32,
                      color: greenColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    width: MediaQuery.of(context).size.width - 100,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffe4faf0),
                    ),
                    child: TextField(
                      onChanged: searchProduct,
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xffb1d8b2),
                        ),
                        hintText: "Search medicine ...",
                        hintStyle: regularTextStyle.copyWith(
                          color: Color(0xffb0d8b2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchController.text.isEmpty || listSearchProduct.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 80),
                    child: WidgetIlustration(
                      title: "There is no medicine that you are looking for",
                      image: "assets/no_data_ilustration.png",
                      subtitle1: "Please find the product you want",
                      subtitle2: "the product will appear here",
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(24),
                        child: GridView.builder(
                          physics: ClampingScrollPhysics(),
                          itemCount: listSearchProduct.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, i) {
                            final y = listSearchProduct[i];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailProduct(productModel: y),
                                  ),
                                );
                              },
                              child: CardProduct(
                                imageProduct: y.imageProduct,
                                nameProduct: y.nameProduct,
                                price: y.price,
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor),
                        onPressed: () {
                          if (listSearchProduct.isNotEmpty) {
                            String idCategory =
                                listSearchProduct.first.idCategory;
                            List<ProductModel> recommendations =
                                getRecommendations(idCategory);
                            showRecommendations(context, recommendations);
                          }
                        },
                        child: Text("Show Recommendations"),
                      ),
                      // ButtonPrimary(
                      //     text: "Show Recommendations",
                      //     onTap: () {
                      //       if (listSearchProduct.isNotEmpty) {
                      //         String idCategory =
                      //             listSearchProduct.first.idCategory;
                      //         List<ProductModel> recommendations =
                      //             getRecommendations(idCategory);
                      //         showRecommendations(context, recommendations);
                      //       }
                      //     })
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void showRecommendations(
      BuildContext context, List<ProductModel> recommendations) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: GridView.builder(
            itemCount: recommendations.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, i) {
              final product = recommendations[i];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailProduct(productModel: product),
                    ),
                  );
                },
                child: CardProduct(
                  imageProduct: product.imageProduct,
                  nameProduct: product.nameProduct,
                  price: product.price,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
