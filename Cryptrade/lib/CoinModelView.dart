import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterprojedata/coinModel.dart';
import 'package:http/http.dart' as http;

class CoinModelView extends ChangeNotifier {
  List<Coin> coinList = [];
  final coinListStreamListController = StreamController<List<Coin>>.broadcast();
  // create a function using StreamController class
  Stream<List<Coin>> coinListStream() async* {
    // stream type function
    // TO CONTROL COINLIST WITH STREAMCONTROLLER
    yield coinList; // yield instead of return
    yield* coinListStreamListController.stream; //*
  }

  List<double> btcVariableList = [];
  final btcVariableListController = StreamController<List<double>>.broadcast();
  Stream<List<double>> btcVariableListStream() async* {
    yield btcVariableList;
    yield* btcVariableListController.stream;
  }

  void updateCoinList(List<Coin> newList) {
    coinList = newList;
    notifyListeners();
  }

  Future<void> fetchCoin() async {
    try {
      coinList = [];
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

      if (response.statusCode == 200) {
        List<dynamic> values = [];
        values = json.decode(response.body);
        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              if (i == 0) {
                btcVariableList.add(values[i]['current_price']);
              }
              Map<String, dynamic> map = values[i];
              coinList.add(Coin.fromJson(map));
            }
          }
        }
        List<double> tempBtcVarList = btcVariableList.reversed.toList();
        btcVariableListController
            .add(tempBtcVarList); // to show BTC in signals screen
        coinListStreamListController
            .add(coinList); // to show the list in the Home page
      }
    } catch (e) {
      print(e.toString());
    }
  }

// FUNCTION TO SEE THE STREAM WHILE PROGRAM IS RUNNING, IN CONSOLE
  Future<void> initFunction() async {
    print("hiiii1");
    await fetchCoin();
    print("hiiii2");
    Timer.periodic(Duration(seconds: 10), (timer) async {
      await fetchCoin();
      DateTime now = DateTime.now();
      print("hiiii3: " + now.second.toString());
    });
  }
}
