import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/helper/env.dart';
import 'package:ddgrandmacau/screens/home.dart';
import 'package:ddgrandmacau/widgeds/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;


class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  late bool isPasswordHide, isLoginProcess;
  TextEditingController emailLogin = TextEditingController(),
      passwordLogin = TextEditingController(),
      passwordRegister = TextEditingController(),
      emailRegister = TextEditingController(),
      passwordConfirmRegister = TextEditingController(),
      phoneRegister = TextEditingController(),
      nameRegister = TextEditingController();
  FocusNode emailFocus = FocusNode(), passwordFocus = FocusNode();
  int _currentIndex = 0;
  @override
  void initState() {
    isLoginProcess = false;
    _currentIndex = 0;
    isPasswordHide = true;
    super.initState();
  }

  @override
  void dispose() {
    emailLogin.dispose();
    passwordLogin.dispose();
    emailFocus.dispose();
    phoneRegister.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void checkRegister() async {
    if(passwordConfirmRegister.text != passwordRegister.text){
      EasyLoading.showError("Password anda tidak sama");
    }else{
      registerFunction();
    }
  }
  void registerFunction() async {
    
    EasyLoading.show(status: 'loading...');
    FocusScope.of(context).unfocus();
    setState(() {
      isLoginProcess = true;
    });
    try {
      final getToken =
          await http.post(Uri.parse(Env.url + 'api/auth/register'), body: {
        "name": nameRegister.text,
        "email": emailRegister.text,
        "password": passwordRegister.text,
        "phone": phoneRegister.text,
      });

      print('getToken ' + getToken.body);

      var getTokenDecode = json.decode(getToken.body);

      print(JsonEncoder.withIndent(' ').convert(getTokenDecode));

      if (getToken.statusCode == 200) {
        setState(() {
          isLoginProcess = false;
        });
        if (getTokenDecode['status']) {
          emailLogin.text = getTokenDecode['data'];
          passwordLogin.clear();
          nameRegister.clear();
          emailRegister.clear();
          phoneRegister.clear();
          passwordRegister.clear();
          passwordConfirmRegister.clear();
          setState(() {
            _currentIndex = 1;
          });
          _currentIndex = 1;
          EasyLoading.showSuccess(getTokenDecode['message']);
        } else if (!getTokenDecode['status']) {
          EasyLoading.showError(getTokenDecode['message']);
        } else {
          EasyLoading.showError(getTokenDecode['message']);
        }
      } else if (getToken.statusCode == 400) {
        setState(() {
          isLoginProcess = false;
        });
        EasyLoading.showError(getTokenDecode['message']);
      } else if (getToken.statusCode == 404) {
        EasyLoading.showError(getTokenDecode['message']);
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

  void loginFunction() async {
    EasyLoading.show(status: 'loading...');
    FocusScope.of(context).unfocus();
    setState(() {
      isLoginProcess = true;
    });
    try {
      final getToken =
          await http.post(Uri.parse(Env.url + 'api/auth/login'), body: {
        "user_id": emailLogin.text,
        "password": passwordLogin.text,
      });
      var getTokenDecode = json.decode(getToken.body);
      
      if (getToken.statusCode == 200) {
        setState(() {
          isLoginProcess = false;
        });
        if (getTokenDecode['status']) {
          EasyLoading.showSuccess(getTokenDecode['message']);
          // set token authentification
          DataStore().setDataString(
              'credential', getTokenDecode['data']['token'].toString());
          DataStore().setDataString(
              'agen_name', getTokenDecode['data']['user']['name'].toString());
          DataStore().setDataString(
              'user_id', getTokenDecode['data']['user']['user_id'].toString());
          DataStore().setDataString(
              'phone',
              getTokenDecode['data']['user']['phone'] != null
                  ? getTokenDecode['data']['user']['phone'].toString()
                  : '-');
          DataStore().setDataString(
              'bank_number',
              getTokenDecode['data']['user']['no_rekening'] != null
                  ? getTokenDecode['data']['user']['no_rekening'].toString()
                  : '-');
                  DataStore().setDataString(
              'bank_id',
              getTokenDecode['data']['user']['nama_bank'] != null
                  ? getTokenDecode['data']['user']['nama_bank'].toString()
                  : '-');
                       DataStore().setDataString(
              'bank_account',
              getTokenDecode['data']['user']['nama_rekening'] != null
                  ? getTokenDecode['data']['user']['nama_rekening'].toString()
                  : '-');
                   DataStore().setDataString(
              'email',
              getTokenDecode['data']['user']['email'] != null
                  ? getTokenDecode['data']['user']['email'].toString()
                  : '-');

          Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
              builder: (BuildContext context) => Home(),
            ),
          );
        } else if (!getTokenDecode['status']) {
          EasyLoading.showError(getTokenDecode['message']);
        } else {
          EasyLoading.showError(getTokenDecode['message']);
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _currentIndex,
      length: 2,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            // construct the profile details widget here
            SizedBox(
              height: 180,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Image.asset('assets/images/logo.png')
                ),
              ),
            ),

            // the tab bar with two items
            SizedBox(
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: (Colors.grey[300])!,
                        blurRadius: 4,
                        offset: Offset(4, 8), // Shadow position
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBar(
                    indicatorColor: Colors.white,
                    indicator: UnderlineTabIndicator(
                        insets: EdgeInsets.symmetric(horizontal: 40.0)),
                    tabs: [
                      Tab(
                        text: "Sign Up",
                      ),
                      Tab(
                        text: "Sign In",
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  Container(
                      margin: EdgeInsets.only(top: 32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TexfieldRoundedPrefix('Enter your full name',
                                  Icon(Icons.person), nameRegister),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldRoundedPrefix('Enter your email',
                                  Icon(Icons.email), emailRegister),
                              SizedBox(
                                height: 16,
                              ),
                                TexfieldRoundedPrefix('Enter your phone',
                                  Icon(Icons.phone), phoneRegister),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldRoundedPrefixPassword('Enter your password',
                                  Icon(Icons.lock), passwordRegister),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldRoundedPrefixPassword(
                                  'Confirm your password', 
                                   Icon(Icons.lock), passwordConfirmRegister),
                              SizedBox(
                                height: 32,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 68, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: isLoginProcess
                                      ? null
                                      : () async {
                                          checkRegister();
                                        },
                                ),
                              )
                            ],
                          ),
                        ),
                      )),

                  // second tab bar viiew widget
                  Container(
                      margin: EdgeInsets.only(top: 32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TexfieldRoundedPrefix('Enter your email',
                                  Icon(Icons.email), emailLogin),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldRoundedPrefixPassword('Enter your password',
                                  Icon(Icons.lock), passwordLogin),
                              SizedBox(
                                height: 16,
                              ),
                              Text("Forgot Password?"),
                              SizedBox(
                                height: 32,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 68, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    onPressed: isLoginProcess
                                        ? null
                                        : () async {
                                            loginFunction();
                                            DataStore ds = DataStore();
                                            String? nm = await ds
                                                .getDataString('user_id');
                                            print(nm);
                                          },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
