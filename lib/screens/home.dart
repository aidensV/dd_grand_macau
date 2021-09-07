import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ddgrandmacau/screens/profil/about.dart';
import 'package:ddgrandmacau/screens/profil/account.dart';
import 'package:ddgrandmacau/authenticate.dart';
import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/screens/order_number/OrderNumber.dart';
import 'package:ddgrandmacau/screens/history/history.dart';
import 'package:ddgrandmacau/provider/HomeProvider.dart';
import 'package:ddgrandmacau/screens/payment/transaction.dart';
import 'package:ddgrandmacau/screens/profil/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.indexParam}) : super(key: key);
  final int? indexParam;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // int _selectedIndex;
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    History(),
    ListTransaction(),
    // WithDraw()
    Profil()
    // Icon(
    //   Icons.chat,
    //   size: 150,
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _onItemTapped(widget.indexParam ?? _selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                BottomIcon(
                  color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                  icon: Icons.home_outlined,
                  iconText: "Depan",
                  onPress: () => {_onItemTapped(0)},
                ),
                BottomIcon(
                  color: _selectedIndex == 1 ? Colors.blue : Colors.black,
                  padding: EdgeInsets.only(right: 30),
                  icon: Icons.history_outlined,
                  iconText: "Pasangan",
                  onPress: () => {_onItemTapped(1)},
                ),
                BottomIcon(
                  color: _selectedIndex == 2 ? Colors.blue : Colors.black,
                  padding: EdgeInsets.only(left: 30),
                  icon: Icons.add_shopping_cart_rounded,
                  iconText: "Bayar",
                  onPress: () => {_onItemTapped(2)},
                ),
                BottomIcon(
                  color: _selectedIndex == 3 ? Colors.blue : Colors.black,
                  icon: Icons.account_circle_outlined,
                  iconText: "Profil",
                  onPress: () => {_onItemTapped(3)},
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OrderNumber()));
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class BottomIcon extends StatelessWidget {
  final String _iconText;
  final IconData _icon;
  final Color _color;
  final VoidCallback? _onPress;

  BottomIcon(
      {@required iconText, @required icon, @required color, onPress, padding})
      : this._iconText = iconText,
        this._onPress = onPress,
        this._icon = icon,
        this._color = color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            onTap: () {},
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                _icon,
                color: _color,
                size: 24,
              ),
              onPressed: _onPress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Text(
              _iconText,
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String agenName = '',
      agenId = '',
      agenPhone = '',
      agenBankNumber = '',
      agenBankId = '',
      agenAccountName = '';
  AnimationController? _animationController;

  void logout() {
    DataStore ds = DataStore();
    ds.logout();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => Authenticate()));
  }

  String dateNow = DateFormat('d-MM-yyyy').format(DateTime.now());
  String timeNow = DateFormat('d-MM-yyyy').format(DateTime.now());
  String _timeString = '';
  var timer;
  void resource() async {
    DataStore ds = DataStore();
    String anm, uid, phn, bnr, bid, bac;
    anm = (await ds.getDataString('agen_name'))!;
    uid = (await ds.getDataString('user_id'))!;
    phn = (await ds.getDataString('phone'))!;
    bnr = (await ds.getDataString('bank_number'))!;
    bid = (await ds.getDataString('bank_id'))!;
    bac = (await ds.getDataString('bank_account'))!;

    setState(() {
      agenName = anm;
      agenId = uid;
      agenPhone = phn;
      agenBankNumber = bnr;
      agenBankId = bid;
      agenAccountName = bac;
    });
  }

  bool isLoading = false, isError = false, isCari = false;
  String errorMessage = '';

  void getNumberMonth() {
    HomeProvider blocX = context.read<HomeProvider>();

    blocX.resource(
      context,
      onBeforeSend: () {
        setState(() {
          isLoading = true;
          isError = false;
        });
      },
      onComplete: () {
        setState(() {
          isLoading = false;
        });
      },
      onErrorAuthorization: () {
        setState(() {
          isError = true;
          errorMessage = 'Token kedaluwarsa silahkan login kembali';
        });
      },
      onErrorCatch: (ini) {
        setState(() {
          isError = true;
          errorMessage = ini;
        });
      },
      onUnknownStatusCode: (kode, text) {
        setState(() {
          isError = true;
          errorMessage = 'Error Code : $kode,\r$text';
        });
      },
    );
  }

  void getWinner() {
    HomeProvider blocX = context.read<HomeProvider>();

    blocX.winner(
      context,
      onBeforeSend: () {
        setState(() {
          isLoading = true;
          isError = false;
        });
      },
      onComplete: () {
        setState(() {
          isLoading = false;
        });

        getBanner();
      },
      onErrorAuthorization: () {
        setState(() {
          isError = true;
          errorMessage = 'Token kedaluwarsa silahkan login kembali';
        });
      },
      onErrorCatch: (ini) {
        setState(() {
          isError = true;
          errorMessage = ini;
        });
      },
      onUnknownStatusCode: (kode, text) {
        setState(() {
          isError = true;
          errorMessage = 'Error Code : $kode,\r$text';
        });
      },
    );
  }

  void getBanner() {
    HomeProvider blocX = context.read<HomeProvider>();

    blocX.banner(
      context,
      onBeforeSend: () {
        setState(() {
          isLoading = true;
          isError = false;
        });
      },
      onComplete: () {
        setState(() {
          isLoading = false;
        });
        getNumberMonth();
      },
      onErrorAuthorization: () {
        setState(() {
          isError = true;
          errorMessage = 'Token kedaluwarsa silahkan login kembali';
        });
      },
      onErrorCatch: (ini) {
        setState(() {
          isError = true;
          errorMessage = ini;
        });
      },
      onUnknownStatusCode: (kode, text) {
        setState(() {
          isError = true;
          errorMessage = 'Error Code : $kode,\r$text';
        });
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Detail Nomor"),
      content: Column(mainAxisSize: MainAxisSize.min, children: []),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    resource();
    getWinner();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _timeString = _formatDateTime(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider bloc = Provider.of<HomeProvider>(context);
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          height: 80,
          color: Colors.blue,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 80,
                  child: Image.asset('assets/images/logo2.png'),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(120))),
                ),
              ),
              Expanded(
                child: Container(
                  height: 80,
                  color: Colors.blue,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.info, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => About()));
                          },
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.yellow[50],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 20,
              child: Marquee(
                text:
                    ' Jadwal Daftar nomor 01 : 00 s/d jam 20:00 wib  |  Batas pembayaran sampai jam 21:00  |   Nomor keluar setiap pukul  22:00 s/d 23:00 wib',
                style: TextStyle(fontWeight: FontWeight.bold),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                // blankSpace: 20.0,
                // velocity: 100.0,
                // pauseAfterRound: Duration(seconds: 1),
                // startPadding: 10.0,
                // accelerationDuration: Duration(seconds: 1),
                // accelerationCurve: Curves.linear,
                // decelerationDuration: Duration(milliseconds: 500),
                // decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        CarouselSlider(
          options: CarouselOptions(height: 120.0),
          items: bloc.listBanner.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Image.network(i.url));
              },
            );
          }).toList(),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: (Colors.grey[300])!,
                blurRadius: 4,
                offset: Offset(4, 4), // Shadow position
              ),
            ],
          ),
//          child: Container(
//   height:50,// requires a finite vertical height
//   child: ListView.builder(
//     itemCount: 50,
//     scrollDirection: Axis.horizontal,
//     itemBuilder: (context, index) {
//       return Column(children: [
//                       Text("Nama Agen",
//                           style:
//                               TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
//                       SizedBox(height: 8),
//                       Text(agenName, style: TextStyle(fontSize: 10)),
//                     ]);

//     }
//   ),
// ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Text("Nama Agen",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(agenName, style: TextStyle(fontSize: 10)),
                  ]),
                  Container(
                      height: 50,
                      child: VerticalDivider(
                          color: Colors.blue, thickness: 2, width: 28)),
                  Column(children: [
                    Text("No. Id Agen",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(agenId, style: TextStyle(fontSize: 10))
                  ]),
                  Container(
                      height: 50,
                      child: VerticalDivider(
                          color: Colors.blue, thickness: 2, width: 28)),
                  Column(children: [
                    Text("No Handphone",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(agenPhone, style: TextStyle(fontSize: 10))
                  ]),
                  Container(
                      height: 50,
                      child: VerticalDivider(
                          color: Colors.blue, thickness: 2, width: 28)),
                  Column(children: [
                    Center(
                      child: Text("Nama Bank",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 8),
                    Text(agenBankId, style: TextStyle(fontSize: 10))
                  ]),
                  Container(
                      height: 50,
                      child: VerticalDivider(
                          color: Colors.blue, thickness: 2, width: 28)),
                  Column(children: [
                    Center(
                      child: Text("No Rekening",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 8),
                    Text(agenBankNumber, style: TextStyle(fontSize: 10))
                  ]),
                  Container(
                      height: 50,
                      child: VerticalDivider(
                          color: Colors.blue, thickness: 2, width: 28)),
                  Column(children: [
                    Center(
                      child: Text("Pemilik",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 8),
                    Text(agenAccountName, style: TextStyle(fontSize: 10))
                  ]),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          color: Colors.blue,
          height: 32,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bloc.dateOfWInner,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  _timeString,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue, width: 4.0),
              boxShadow: [
                BoxShadow(
                  color: (Colors.grey[300])!,
                  blurRadius: 4,
                  offset: Offset(4, 4), // Shadow position
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(24))),
          height: 90,
          width: 230,
          child: Center(
              child: Text(
            bloc.numberOfWInner,
            style: TextStyle(shadows: <Shadow>[
              Shadow(
                offset: Offset(4.0, 4.0),
                blurRadius: 3.0,
                color: (Colors.grey[300])!,
              ),
              Shadow(
                offset: Offset(4.0, 4.0),
                blurRadius: 8.0,
                color: (Colors.grey[300])!,
              ),
            ], fontWeight: FontWeight.bold, fontSize: 64, color: Colors.blue),
          )),
        ),
        SizedBox(height: 16),
        Text("Daftar No Sebelumnya",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          color: Colors.white,
          child: Column(children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: (Colors.grey[200])!,
                  blurRadius: 4,
                  offset: Offset(4, 4), // Shadow position
                ),
              ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("No",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text("Tanggal",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text("Nomor",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ),
            MediaQuery.removePadding(
              context: context,
              // removeTop: true,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bloc.filter().length,
                  itemBuilder: (context, index) {
                    var d = bloc.filter()[index];
                    Color? oddEven =
                        index % 2 == 0 ? Colors.white : (Colors.grey[50]);
                    return GestureDetector(
                      onTap: () {
                        // showAlertDialog(context);
                      },
                      child: Container(
                        width: double.infinity,
                        color: oddEven,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(d.no,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(d.date,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(d.number,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(Icons.chevron_right,
                                        color: Colors.blue)),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height: 38),
          ]),
        )
      ]),
    );
  }
}
