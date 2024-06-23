import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medhealth/network/api/url_api.dart';
import 'package:medhealth/network/model/history_model.dart';
import 'package:medhealth/network/model/pref_profile_model.dart';
import 'package:medhealth/widget/card_history.dart';
import 'package:medhealth/widget/widget_ilustration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryOrderModel> list = [];
  String? userID;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUser);
    });
    getHistory();
  }

  getHistory() async {
    list.clear();
    var urlHistory = Uri.parse(BASEURL.apiHistory + userID!);
    final response = await http.get(urlHistory);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map item in data) {
          list.add(HistoryOrderModel.fromJson(item as Map<String, dynamic>));
        }
      });
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
        child: ListView(children: [
          Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              height: 70,
              child: Text(
                "History Order",
                style: regularTextStyle.copyWith(fontSize: 25),
              )),
          SizedBox(
            height: (list.length == 0) ? 80 : 20,
          ),
          list.length == 0
              ? Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: WidgetIlustration(
                      image: "assets/no_history_ilustration.png",
                      title: "Oops, there are no history order",
                      subtitle1: "You don't have history order",
                      subtitle2: "Let's shopping now",
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: ((context, i) {
                    final x = list[i];
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: CardHistory(
                        model: x,
                      ),
                    );
                  })),
        ]),
      ),
    );
  }
}
