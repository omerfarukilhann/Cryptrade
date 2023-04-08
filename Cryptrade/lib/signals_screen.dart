import 'package:flutter/material.dart';
import 'package:flutterprojedata/CoinModelView.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class SignalsScreen extends StatefulWidget {
  @override
  _SignalsScreenState createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Buy-Sell signals for BTC'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 24),
                width: double.infinity,
                height: 190,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.ctfassets.net/q33z48p65a6w/2lLSJ9g1lQXBLzqprDR8iE/2372fb32b016474077f34ef5c5202624/2204_BlogHeader_Wallet.png?w=1200&h=645&fit=thumb"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 10,
                      color: Colors.black54,
                      spreadRadius: -5,
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF08AEEA),
                      Color(0xFF2AF598),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<double>>(
                    stream:
                        context.read<CoinModelView>().btcVariableListStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("ERROR");
                      } else if (snapshot.hasData) {
                        return ListView.separated(
                          itemBuilder: (context, index) => ListTile(
                            leading: Text(
                              (index + 1).toString(),
                            ),
                            title: Text(
                              (snapshot.data![index]).toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: showSnackBarMethod(snapshot.data!),
                          ),
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: snapshot.data!.length,
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showSnackBarMethod(List<double> btcVarList) {
    if (btcVarList.isNotEmpty) {
      if (btcVarList.length >= 2) {
        if (btcVarList[0] < btcVarList[1]) {
          return Text(
            'Buy',
            style: TextStyle(color: Colors.green),
          );
        } else if (btcVarList[0] > btcVarList[1]) {
          return Text(
            'Sell',
            style: TextStyle(color: Colors.red),
          );
        } else {
          return Text('');
        }
      }
    }
    return Text('');
  }
}
