import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojedata/BotTrader.dart';
import 'package:flutterprojedata/CoinModelView.dart';
import 'package:flutterprojedata/botpage_screen.dart';
import 'package:flutterprojedata/signals_screen.dart';
import 'package:provider/provider.dart';

import 'coinCard.dart';
import 'coinModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CoinModelView>(create: (_) => CoinModelView())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    context.read<CoinModelView>().initFunction();
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<List<Coin>>(
          stream: context.read<CoinModelView>().coinListStream(),
          builder: (context, snapdata) {
            switch (snapdata.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapdata.hasError) {
                  print(snapdata.error);
                  return Text('Please Wait....');
                } else {
                  if (snapdata.data!.length == 0) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return BuildCoinWidget(snapdata.data!);
                }
            }
          },
        ),
      ),
    );
  }

  Widget BuildCoinWidget(List<Coin> coinList) {
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
        backgroundColor: Colors.transparent,
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Portfolio',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Stack(children: [
                Positioned(
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Icon(Icons.notifications_none_outlined),
              ]),
              onPressed: () {},
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                // TOP CONTAINER
                margin: EdgeInsets.only(bottom: 24),
                width: double.infinity,
                height: 190,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://s3.cointelegraph.com/storage/uploads/view/d2a9c6fc8b5e3a859532ee57d36a4537.png"),
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
              Row(
                // ROW INCLUDING DEFINITION AND ADD BUTTON
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' Coin list',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                // PADDING FOR BODY
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 10, // HOW MANY COINS WE WANT TO SHOW
                  itemBuilder: (context, index) {
                    return CoinCard(
                      name: coinList[index].name,
                      symbol: coinList[index].symbol,
                      imageUrl: coinList[index].imageUrl,
                      price: coinList[index].price.toDouble(),
                      change: coinList[index].change.toDouble(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context),
              ],
            ),
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          //  -WHAT IS THIS FOR
        ),
        child: Column(children: const [
          CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage('https://picsum.photos/250?image=9'),
          ),
          SizedBox(height: 12),
          Text('Omer Faruk Ilhan',
              style: TextStyle(fontSize: 28, color: Colors.black)),
          Text('omerfaruk.ilhan@agu.edu.tr',
              style: TextStyle(fontSize: 16, color: Colors.black))
        ]),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(56),
        child: Wrap(
          // WHY WRAP
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Home(),
              )),
            ),
            ListTile(
              leading: const Icon(Icons.wallet_outlined),
              title: const Text('Wallet'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Home(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.paid_outlined),
              title: const Text('Signals'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignalsScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Trade'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BotTrader(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.thumbs_up_down_outlined),
              title: const Text('Bot information'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BotPageScreen(),
                ));
              },
            ),
          ],
        ),
      );
}
