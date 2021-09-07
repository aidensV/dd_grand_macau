import 'package:ddgrandmacau/provider/HomeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isLoading = false;
  bool isError = false;
  List listReward = [];
  String errorMessage = '';

  void resources() {
    HomeProvider blocX = context.read<HomeProvider>();

    blocX.about(
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    resources();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider bloc = Provider.of<HomeProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text("Tentang Kami")),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // construct the profile details widget here
            SizedBox(
              height: 64,
            ),
            SizedBox(
              child: Container(
                width: 180,
                color: Colors.white,
                child: Center(
                    child: Column(
                  children: [
                    Image.asset('assets/images/logo_big_blue.png'),
                    Text("Versi 1.0.3")
                  ],
                )),
              ),
            ),
            SizedBox(
              height: 64,
            ),

            // create widgets for each tab bar here
            Expanded(
              child: SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // first tab bar view widget
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Harga Pernomor#",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900)),
                                  Text("1x = 1000",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.blueAccent)),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Reward#",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900))),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: bloc.filterAbout().length,
                                itemBuilder: (context, index) {
                                  var data = bloc.filterAbout()[index];
                                  return ListTile(
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(
                                          child: Icon(Icons.confirmation_number,
                                              color: index == 0 ? Colors.blueAccent: index == 1 ? Colors.green : Colors.redAccent)),
                                    ),
                                    title: Text(data.desc!),
                                    trailing: Text(data.value!),
                                  );
                                }),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.yellow[50],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  padding: EdgeInsets.all(16.0),
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Jadwal Daftar Nomor #",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900)),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                            "Jam 01 : 00 s/d jam 20:00 wib",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200)),
                                      ),
                                      SizedBox(height: 8),
                                      Text("Batas pembayaran #",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900)),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                            "Batas pembayaran sampai jam 21:00 wib",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200)),
                                      ),
                                      SizedBox(height: 8),
                                      Text("Nomor keluar setiap pukul #",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900)),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text("22:00 s/d 23:00 wib",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200)),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )),

                    // second tab bar viiew widget
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
