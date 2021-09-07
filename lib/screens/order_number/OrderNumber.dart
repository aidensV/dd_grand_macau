import 'dart:convert';

import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/screens/order_number/payment.dart';
import 'package:ddgrandmacau/provider/OrderProvider.dart';
import 'package:ddgrandmacau/widgeds/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderNumber extends StatefulWidget {
  const OrderNumber({Key? key}) : super(key: key);

  @override
  _OrderNumberState createState() => _OrderNumberState();
}

class _OrderNumberState extends State<OrderNumber> {
  TextEditingController nameController = TextEditingController(),
      phoneController = TextEditingController(),
      qtyController = TextEditingController(),
      numberController = TextEditingController();
  bool isLoading = false, isError = false, isSendRequest = false;
  String errorMessage = '';
  void resources() {
    OrderProvider blocX = context.read<OrderProvider>();

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

  String dateNow = DateFormat('d-MM-yyyy').format(DateTime.now());
  String agenName = '', agenId = '', agenPhone = '', agenBankNumber = '';
  void getDataUser() async {
    DataStore ds = DataStore();
    String anm, uid, phn, bnr;
    anm = (await ds.getDataString('agen_name'))!;
    uid = (await ds.getDataString('user_id'))!;
    phn = (await ds.getDataString('phone'))!;
    bnr = (await ds.getDataString('bank_number'))!;

    setState(() {
      agenName = anm;
      agenId = uid;
      agenPhone = phn;
      agenBankNumber = bnr;
      nameController.text = anm;
      phoneController.text = phn;
    });

    resources();
  }

  bool simpan() {
    EasyLoading.show(status: 'loading...');
    OrderProvider blocX = context.read<OrderProvider>();
    Map form = Map();

    form.addAll({
      'nama': nameController.text,
      'phone': phoneController.text,
      'nomor': numberController.text,
      'jumlah': qtyController.text,
      'harga': blocX.price.toString(),
      'total': (blocX.price * int.parse(qtyController.text)).toString(),
      'user_id': agenId
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
          nameController.clear();
          phoneController.clear();
          numberController.clear();
          qtyController.clear();
          EasyLoading.dismiss();
          resources();
          return true;
        } else if (!data['status']) {
          EasyLoading.showError(data['message']);
          EasyLoading.dismiss();
          return false;
        }
      },
    );
    EasyLoading.dismiss();
    return false;
  }

   bool delete(id) {
    EasyLoading.show(status: 'loading...');
    OrderProvider blocX = context.read<OrderProvider>();
    Map form = Map();

    form.addAll({
      'peserta_id': id.toString()
    });

    blocX.delete(
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
        print(data['message']);
        if (data['status']) {
          EasyLoading.showSuccess(data['message']);
          resources();
          EasyLoading.dismiss();
          return true;
        } else if (!data['status']) {
          EasyLoading.showError(data['message']);
          EasyLoading.dismiss();
          return false;
        }
      },
    );
    EasyLoading.dismiss();
    return false;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    getDataUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderProvider bloc = Provider.of<OrderProvider>(context);
    int subTotal = bloc.subtotalPayment;
    double tax = (bloc.subtotalPayment * 0.2);
    int totalPay = subTotal - tax.toInt();

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sub Total",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(subTotal.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("20%",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                        Text(totalPay.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ],
                    ),
                  ]),
                )),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: bloc.filter().length < 1
                    ? null
                    : () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Payment()));
                      },
                child: Text('Lanjut'),
              ),
            ),
          ],
        ),
      ),
      body: Column(children: [
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
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                            title: new Text('Tambah Data'),
                            content: SingleChildScrollView(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TexfieldPrefix("Nama Agen", Icon(Icons.person),
                                        nameController),
                                    SizedBox(height: 16),
                                    TexfieldPrefix("No Hp Agen",
                                        Icon(Icons.phone), phoneController,typeKeyboard: TextInputType.phone),
                                    SizedBox(height: 16),
                                    TexfieldPrefix(
                                      "Angka",
                                      Icon(Icons.format_list_numbered),
                                      numberController,
                                      maxLength: 4,
                                      typeKeyboard: TextInputType.number,
                                    ),
                                    SizedBox(height: 16),
                                    TexfieldPrefix(
                                      "Jumlah",
                                      Icon(Icons.format_list_numbered),
                                      qtyController,
                                      typeKeyboard: TextInputType.number,
                                    ),
                                  ]),
                            ),
                            actions: <Widget>[
                              new TextButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(); // dismisses only the dialog and returns nothing
                                },
                                child: new Text('Batal'),
                              ),
                              new ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  EasyLoading.show(status: 'loading...');
                                  simpan();
                                  resources();
                                  return Future.value('');
                                },
                                child: new Text('Simpan'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Daftar Pesanan Belum Terbayar",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: bloc.filter().length < 1
                ? Center(
                    child: Container(
                      width: 180,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/coins.gif'),
                          Text("Tidak Ada Data")
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      resources();
                      return Future.value('');
                    },
                    child: ListView.builder(
                        itemCount: bloc.filter().length,
                        itemBuilder: (context, index) {
                          var d = bloc.filter()[index];
                          return Card(
                              elevation: 0,
                              child: ListTile(
                                trailing: IconButton(
                                  onPressed: () {
                                    // set up the buttons
                                    Widget cancelButton = ElevatedButton(
                                      child: Text("Batal"),
                                      onPressed: () {
                                       Navigator.pop(context);
                                      },
                                    );
                                    Widget continueButton = TextButton(
                                      child: Text("Hapus"),
                                      onPressed: () {
                                         delete(d.id);
                                         Navigator.pop(context);
                                      },
                                    );

                                    // set up the AlertDialog
                                    AlertDialog alert = AlertDialog(
                                      title: Text("Peringatan"),
                                      content: Text(
                                          "Apakah anda yakin akan menghapus nomor ini?"),
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
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                                title: Row(
                                  children: [
                                    Text(d.name ?? '-'),
                                    SizedBox(width: 8),
                                    Text('-'),
                                    SizedBox(width: 8),
                                    Text(d.qty ?? '-',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold)),
                                    Text('x',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                subtitle: Text(d.phone ?? '-'),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Center(
                                      child: Text(d.number ?? '-',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent))),
                                ),
                              ));
                        }),
                  ),
          ),
        )
      ]),
    );
  }
}
