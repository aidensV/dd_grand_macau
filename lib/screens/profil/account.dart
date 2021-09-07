import 'dart:convert';
import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/provider/HomeProvider.dart';
import 'package:ddgrandmacau/widgeds/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late bool isPasswordHide, isLoginProcess;
  TextEditingController emailLogin = TextEditingController(),
      name = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController(),
      userid = TextEditingController(),
      bankId = TextEditingController(),
      bankAccount = TextEditingController(),
      bankNumber = TextEditingController(),
      nameRegister = TextEditingController();
  FocusNode emailFocus = FocusNode(), passwordFocus = FocusNode();
  bool isLoading = false, isError = false, isSendRequest = false;
  String errorMessage = '';

  @override
  void initState() {
    isLoginProcess = false;

    isPasswordHide = true;
    resource();
    super.initState();
  }

  @override
  void dispose() {
    emailLogin.dispose();

    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void resource() async {
    DataStore ds = DataStore();
    String anm, uid, phn, bnr, bac, bid,eml;
    anm = (await ds.getDataString('agen_name'))!;
    uid = (await ds.getDataString('user_id'))!;
    phn = (await ds.getDataString('phone'))!;
    eml = (await ds.getDataString('email'))!;
    bnr = (await ds.getDataString('bank_number'))!;
    bac = (await ds.getDataString('bank_account'))!;
    bid = (await ds.getDataString('bank_id'))!;

    setState(() {
      name.text = anm;
      email.text = eml;
      phone.text = phn == '-' ? '': phn ;
      userid.text = uid;
      bankAccount.text = bac == '-' ? '': bac ;
      bankId.text = bid  == '-' ? '': bid ;
      bankNumber.text = bnr == '-' ? '' :bnr ;
    });
  }

  bool simpan() {
    EasyLoading.show(status: 'loading...');
    HomeProvider blocX = context.read<HomeProvider>();
    Map form = Map();
    form.addAll({
      'rekening_nama': bankAccount.text != '' ? bankAccount.text: '-',
      'rekening_nomor': bankNumber.text != '' ? bankNumber.text :'-',
      'bank_nama': bankId.text != '' ? bankId.text :'-',
      'phone': phone.text,
    });

    blocX.simpan(
      context,
      form: form,
      onBeforeSend: () {
        setState(() {
          isSendRequest = true;
        });
      },
      onComplete: () {
        setState(() {
          isSendRequest = false;
        });
      },
      onSuccess: (ini) {
        var data = jsonDecode(ini);

        if (data['status']) {
        print(data['data']['phone']);
        print(phone.text);
        setState((){
            DataStore().setDataString(
              'phone',
              data['data']['phone'] != null
                  ? data['data']['phone'].toString()
                  : '-');
          DataStore().setDataString(
              'bank_number',
              data['data']['no_rekening'] != null
                  ? data['data']['no_rekening'].toString()
                  : '-');
          DataStore().setDataString(
              'bank_account',
              data['data']['nama_rekening'] != null
                  ? data['data']['nama_rekening'].toString()
                  : '-');
                    DataStore().setDataString(
              'bank_id',
              data['data']['nama_bank'] != null
                  ? data['data']['nama_bank'].toString()
                  : '-');
        });
          // Navigator.pop(context, data['message']);
          EasyLoading.showSuccess(data['message']);
          resource();
          return true;
        } else if (!data['status']) {
          EasyLoading.showError(data['message']);
          return false;
        }
      },
    );
    EasyLoading.dismiss();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Update Profile")),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          // construct the profile details widget here
          SizedBox(
            height: 80,
            child: Container(
              color: Colors.blue,
              child: Center(child: Image.asset('assets/images/logo.png')),
            ),
          ),

          // the tab bar with two items
          SizedBox(
            height: 30,
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
            ),
          ),

          // create widgets for each tab bar here
          Expanded(
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  // first tab bar view widget
                  Container(
                      margin: EdgeInsets.only(top: 32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TexfieldRoundedPrefixDisabled(
                                  'Enter your full name',
                                  Icon(Icons.person),
                                  userid),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldRoundedPrefixDisabled(
                                  'Enter your full name',
                                  Icon(Icons.person),
                                  name),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldRoundedPrefixDisabled(
                                  'Enter your email', Icon(Icons.email), email),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldPrefix('Masukan Nomor Telepon Anda', Icon(Icons.phone), phone),
                              Divider(),
                              // Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text("Data rekening")),
                              // SizedBox(
                              //   height: 16,
                              // ),
                              // TexfieldPrefix('Masukan Nama Bank',
                              //     Icon(Icons.monetization_on_outlined), bankId),
                              // SizedBox(
                              //   height: 16,
                              // ),
                              // TexfieldPrefix(
                              //     'Nama Pemilik',
                              //     Icon(Icons.monetization_on_outlined),
                              //     bankAccount),
                              // SizedBox(
                              //   height: 16,
                              // ),
                              // TexfieldPrefix(
                              //     'Masukan Nomor Rekening',
                              //     Icon(Icons.monetization_on_outlined),
                              //     bankNumber),
                              // SizedBox(
                              //   height: 16,
                              // ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Text("Simpan"),
                                  onPressed: () {
                                    simpan();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 100,
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
    );
  }
}
