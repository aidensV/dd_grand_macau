import 'package:ddgrandmacau/authenticate.dart';
import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/screens/profil/about.dart';
import 'package:ddgrandmacau/screens/profil/account.dart';
import 'package:ddgrandmacau/screens/profil/account_bank.dart';
import 'package:ddgrandmacau/screens/profil/change_password.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool isLoading = false, isError = false, isSendRequest = false;
  String name = 'nama belum diset';
  String errorMessage = '';

  @override
  void initState() {
    resource();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void resource() async {
    DataStore ds = DataStore();
    String anm, uid, phn, bnr, bac, bid, eml;
    anm = (await ds.getDataString('agen_name'))!;
    uid = (await ds.getDataString('user_id'))!;
    phn = (await ds.getDataString('phone'))!;
    eml = (await ds.getDataString('email'))!;
    bnr = (await ds.getDataString('bank_number'))!;
    bac = (await ds.getDataString('bank_account'))!;
    bid = (await ds.getDataString('bank_id'))!;

    setState(() {
      name = anm;
      // email.text = eml;
      // phone.text = phn == '-' ? '': phn ;
      // userid.text = uid;
      // bankAccount.text = bac == '-' ? '': bac ;
      // bankId.text = bid  == '-' ? '': bid ;
      // bankNumber.text = bnr == '-' ? '' :bnr ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // construct the profile details widget here
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
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(120))),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 80,
                    color: Colors.blue,
                    child: Align(
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
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
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Account()));
                                },
                                leading: CircleAvatar(
                                  radius: 30.0,
                                  foregroundColor: Colors.blue,
                                  backgroundColor: Colors.lightBlue,
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/avataaars.png',
                                      fit: BoxFit.cover,
                                      width: 60.0,
                                      height: 60.0,
                                    ),
                                  ),
                                  // backgroundImage: NetworkImage(
                                  //     'https://via.placeholder.com/150'),
                                ),
                                title: Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: Icon(Icons.chevron_right_outlined,
                                    color: Colors.blue),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Account()));
                                },
                                leading: Icon(Icons.person),
                                title: Text("Profile"),
                              ),
                              Divider(),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AccountBank()));
                                },
                                leading: Icon(Icons.business),
                                title: Text("Data Bank"),
                              ),
                              Divider(),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePassword()));
                                },
                                leading: Icon(Icons.lock),
                                title: Text("Ganti Password"),
                              ),
                              Divider(),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => About()));
                                },
                                leading: Icon(Icons.info),
                                title: Text("Tentang Kami"),
                              ),
                              Divider(),
                              SizedBox(height: 32),
                              SizedBox(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  child: Text("Logout",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                  onPressed: () {
                                    // set up the buttons
                                    Widget cancelButton = ElevatedButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                    Widget continueButton = TextButton(
                                      child: Text("Continue"),
                                      onPressed: () {
                                        DataStore ds = DataStore();
                                        ds.logout();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Authenticate()));
                                      },
                                    );

                                    // set up the AlertDialog
                                    AlertDialog alert = AlertDialog(
                                      title: Text("Peringatan"),
                                      content: Text(
                                          "Apakah anda yakin akan keluar dari akun ini?"),
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
                                  },
                                ),
                              ),
                              SizedBox(height: 32),
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
