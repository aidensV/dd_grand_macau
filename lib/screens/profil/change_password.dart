import 'dart:convert';
import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/provider/HomeProvider.dart';
import 'package:ddgrandmacau/widgeds/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late bool isPasswordHide, isLoginProcess;
  TextEditingController oldPassword = TextEditingController(),
      newPassword = TextEditingController(),
      newPasswordConfirm = TextEditingController();
  late String name, userid;
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
    oldPassword.dispose();
    newPassword.dispose();
    newPasswordConfirm.dispose();
    super.dispose();
  }

  void resource() async {
    DataStore ds = DataStore();
    String anm, uid;
    anm = (await ds.getDataString('agen_name'))!;
    uid = (await ds.getDataString('user_id'))!;

    setState(() {
      name = anm;
      userid = uid;
    });
  }

  void validation(){
    if(newPassword.text  == newPasswordConfirm.text){
       simpan();
    }else{
      EasyLoading.showError("Password tidak sama");
    }
  }

  bool simpan() {
    EasyLoading.show(status: 'loading...');
    HomeProvider blocX = context.read<HomeProvider>();
    Map form = Map();
    form.addAll({
      'password_new': newPassword.text,
      'password_old': oldPassword.text,
      'user_id': userid,
    });

    blocX.changePassword(
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
          
          oldPassword.clear();
          newPassword.clear();
          newPasswordConfirm.clear();
          // Navigator.pop(context, data['message']);
          EasyLoading.showSuccess(data['message']);
          return true;
        } else if (!data['status']) {
          EasyLoading.showError(data['message']);
          return false;
        }
      },
      onErrorCatch: (ini){
        var data = jsonDecode(ini);
          EasyLoading.showError(data['message']);
          return false;
      }
    );
    EasyLoading.dismiss();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Ganti Password")),
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
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Ganti Password")),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldPrefix('Password Lama', Icon(Icons.lock),
                                
                                  oldPassword,
                                  obscureText: true,
                                  ),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldPrefix('Password Baru', Icon(Icons.lock),
                                  newPassword,
                                  obscureText: true,),
                              SizedBox(
                                height: 16,
                              ),
                              TexfieldPrefix('Konfirmasi Password Baru',
                                  Icon(Icons.lock), newPasswordConfirm,obscureText: true,),
                              SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Text("Simpan"),
                                  onPressed: () {
                                    validation();
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
