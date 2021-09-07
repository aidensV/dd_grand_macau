import 'dart:convert';

import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/screens/home.dart';
import 'package:ddgrandmacau/provider/OrderProvider.dart';
import 'package:ddgrandmacau/screens/payment/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController nameController = TextEditingController(),
      phoneController = TextEditingController(),
      numberController = TextEditingController();
  bool isLoading = false, isError = false, isSendRequest = false;
  String errorMessage = '';
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  
  String agenName = '', agenId = '', agenPhone = '', agenBankNumber = '';
  void resource() async {
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
    });
  }

  void index() {
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

  void resources() {
    OrderProvider blocX = context.read<OrderProvider>();

    blocX.getDataPayment(
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
        resource();
        index();
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

  bool simpan() {
    EasyLoading.show(status: 'loading...');
    OrderProvider blocX = context.read<OrderProvider>();
    Map form = Map();
    int subTotal = blocX.subtotalPayment;
    double tax = (blocX.subtotalPayment * 0.2);
    int totalPay = subTotal - tax.toInt();
    String periode = DateFormat('yyyy-MM-dd').format(DateTime.now());
    for (int i = 0; i < blocX.filter().length; i++) {
      print(blocX.filter()[i].id.toString());
      form.addAll({'peserta_id[$i]': blocX.filter()[i].id.toString()});
    }
    // print(totalPay);
    form.addAll({
      'bank_id': blocX.paymentBankId,
      'jumlah': totalPay.toString(),
      'tanggal': periode,
      'user_id': agenId
    });

    blocX.bayar(
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
    resources();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderProvider bloc = Provider.of<OrderProvider>(context);
    int subTotal = bloc.subtotalPayment;
    double tax = (bloc.subtotalPayment * 0.2);
    int totalPay = subTotal - tax.toInt();

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 32),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(bloc.paymentImage),
                        Text(
                            "Silahkan melakukan pembayaran pada nomor rekening berikut"),
                        SizedBox(
                          height: 8,
                        ),
                        Text(bloc.paymentAccountNumber,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.blue)),
                        Text(bloc.paymentAccountName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(),
                        Text("Total Pembayaran",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black)),
                        Text(formatCurrency.format(totalPay),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.blue)),
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
                                    borderRadius: BorderRadius.circular(8))),
                            child: Text(
                              'Bayar',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () async {
                              simpan();
                               Navigator.push(context,MaterialPageRoute(builder: (context) => Home(indexParam:2) ));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}
