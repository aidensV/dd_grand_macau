import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ddgrandmacau/authenticate.dart';
import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/helper/env.dart';
import 'package:ddgrandmacau/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoginProcess = false;
  static const _url = 'https://drive.google.com/file/d/1nOXLBgpRx61aHRDLUjQOSxa6X3cinS91/view';

  void redirect() async {
    var token = await DataStore().getDataString("credential");
    Timer(Duration(seconds: 4), () {
      if (token == 'Kosong') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Authenticate()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }

  showAlertDialog() {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text("Update"),
      onPressed: () async{
        await canLaunch(_url)
              ? await launch(_url)
              : throw 'Could not launch $_url';
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Silahkan Update Aplikasi Anda.."),
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

  void checkVersion() async {
    setState(() {
      isLoginProcess = true;
    });
    try {
      final getToken = await http.get(Uri.parse(Env.url + 'api/check-version'));
      var getTokenDecode = json.decode(getToken.body);

      if (getToken.statusCode == 200) {
        setState(() {
          isLoginProcess = false;
        });
        if (getTokenDecode['status']) {
          if (getTokenDecode['data'] == '1.0.3') {
            redirect();
          } else {
            showAlertDialog();
          }
        } else {
          showAlertDialog();
        }
      } else if (getToken.statusCode == 400) {
        setState(() {
          isLoginProcess = false;
        });
        EasyLoading.showError(getTokenDecode['message']);
      } else if (getToken.statusCode == 404) {
        EasyLoading.showError(ErrorApi.error404);
        setState(() {
          isLoginProcess = false;
        });
      } else {
        EasyLoading.showError(getTokenDecode['message']);
        setState(() {
          isLoginProcess = false;
        });
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError(ErrorApi.timeout);
      setState(() {
        isLoginProcess = false;
      });
    } on SocketException catch (_) {
      print('error socket');
      Fluttertoast.showToast(
                msg:
                    'Tidak ada koneksi.. silahkan coba lagi');
      EasyLoading.showError(ErrorApi.exception);
      setState(() {
        isLoginProcess = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoginProcess = false;
      });
      EasyLoading.showError(ErrorApi.exception);
    }

    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // redirect();
    checkVersion();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo2.png'),
              SizedBox(
                width: 250.0,
                child: TextLiquidFill(
                  loadDuration: const Duration(seconds: 4),
                  text: 'TEBAK ANGKA',
                  waveColor: Colors.blueAccent,
                  boxBackgroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  boxHeight: 100.0,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            Text("V 1.0.3")
          ],
        ),
      ),
    );
  }
}
