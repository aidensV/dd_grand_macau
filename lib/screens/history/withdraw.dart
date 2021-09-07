import 'dart:convert';

import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/provider/HistoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class WithDraw extends StatefulWidget {
  const WithDraw({Key? key, required this.id,required this.qty, required this.name, required this.number}) : super(key: key);
  final String id;
  final String qty;
  final String name;
  final String number;
  @override
  _WithDrawState createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDraw> {
  late bool isPasswordHide, isLoginProcess;
  TextEditingController emailLogin = TextEditingController(),
      name = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController(),
      userid = TextEditingController(),
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
    String anm, uid, phn;
    anm = (await ds.getDataString('agen_name'))!;
    uid = (await ds.getDataString('user_id'))!;
    phn = (await ds.getDataString('phone'))!;
    // bnr = (await ds.getDataString('bank_number'))!;

    setState(() {
      name.text = anm;
      phone.text = phn;
      userid.text = uid;
    });
  }



   bool simpan() {
    EasyLoading.show(status: 'loading...');
    HistoryProvider blocX = context.read<HistoryProvider>();
    Map form = Map();
  
    form.addAll({
      'peserta_id': widget.id,
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
        print(data);
        if (data['status']) {
          // Navigator.pop(context, data['message']);
          EasyLoading.showSuccess(data['message']);
          
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

  showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text("Continue"),
    onPressed:  () {
      simpan();
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Peringatan"),
    content: Text("Apakah anda yakin akan melakukan withdraw?"),
    actions: [
      cancelButton,
      continueButton,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // construct the profile details widget here
          SizedBox(
            height: 140,
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
            child: Column(
              children: [
                // first tab bar view widget
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16),
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: (Colors.grey[200])!,
                          blurRadius: 4,
                          offset: Offset(4, 4), // Shadow position
                        ),
                      ]),
                      margin: EdgeInsets.only(top: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  // Expanded(
                                  //   child: TexfieldPrefix(
                                  //     "Angka",
                                  //     Icon(Icons.format_list_numbered),
                                  //     name,
                                  //     maxLength: 4,
                                  //     typeKeyboard: TextInputType.number,
                                  //   ),
                                  // ),
                                  // IconButton(
                                  //   icon: Icon(Icons.search),
                                  //   onPressed: () => {},
                                  // )
                                ],
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Nama",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(widget.name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Jumlah",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(widget.qty,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Divider(),
                                      Text("Nomor",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 8),
                                      Text(widget.number,
                                          style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange)),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        
                                        onPressed: () {
                                          showAlertDialog(context);
                                        },
                                        child: const Text('Withdraw'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ),

                // second tab bar viiew widget
              ],
            ),
          ),
        ],
      ),
    );
  }
}
