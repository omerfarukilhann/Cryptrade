import 'package:flutter/material.dart';

import 'main.dart';

class BotTrader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff1f005c),
            Color(0xff5b0060),
            Color(0xff870160),
            Color(0xffac255e),
            Color(0xffca485c),
            Color(0xffe16b5c),
            Color(0xfff39060),
            Color(0xffffb56b),
          ],
        ),
      ),
      child: Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0,
          title: Text(
            'Trade',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(),
            TransactionList(),
          ],
        ),
      ),
    );
  }
}

class Transaction {
  final String id;
  final String name;
  final String surname;
  final String gpd;

  Transaction(
      {required this.id,
      required this.name,
      required this.surname,
      required this.gpd});
}

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final List<Transaction> transactions = [];
  final idContoller = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final gpdController = TextEditingController();
  void addTransaction(
      String txid, String txname, String txsurname, String txgpd) {
    final newTx =
        Transaction(id: txid, name: txname, surname: txsurname, gpd: txgpd);
    setState(() {
      transactions.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Coin Verification Code'),
                  controller: idContoller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Buy, Sell, SelfMade'),
                  controller: nameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Start From'),
                  controller: surnameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Finish At'),
                  controller: gpdController,
                ),
                Center(
                  child: TextButton(
                    child: Text('Trade'),
                    onPressed: () {
                      print(idContoller.text);
                      print(nameController.text);
                      print(surnameController.text);
                      print(gpdController.text);
                      addTransaction(idContoller.text, nameController.text,
                          surnameController.text, gpdController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white30,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: transactions.map((tx) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("CVC :" + tx.id,
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center),
                              Text("Process :" + tx.name,
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Start from: " + tx.gpd,
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center),
                                Text("Finish at:" + tx.surname,
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ], //column children
                    ),
                  ), //row
                ),
              ); //card
            }).toList(), //map
          ),
        ),
      ],
    ); //column
  }
}
