import 'dart:convert';

import 'package:ddgrandmacau/provider/HistoryProvider.dart';
import 'package:ddgrandmacau/provider/OrderProvider.dart';
import 'package:ddgrandmacau/screens/history/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isLoading = false, isError = false, isCari = false;
  String errorMessage = '';
  void resources() {
    HistoryProvider blocX = context.read<HistoryProvider>();

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

  bool delete(id) {
    EasyLoading.show(status: 'loading...');
    OrderProvider blocX = context.read<OrderProvider>();
    Map form = Map();

    form.addAll({'peserta_id': id.toString()});

    blocX.delete(
      context,
      form: form,
      onBeforeSend: () {
        // setState(() {
        //   isSendRequest = true;
        // });
        EasyLoading.show(status: 'loading...');
      },
      onComplete: () {
        // setState(() {
        //   isSendRequest = false;
        // });
        EasyLoading.dismiss();
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

  String dateNow = DateFormat('d-MM-yyyy').format(DateTime.now());
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
    HistoryProvider bloc = Provider.of<HistoryProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
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
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(120))),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 80,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Pasangan Tanggal $dateNow",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          ),
          SizedBox(height: 16),
          bloc.filter().length < 1
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
              : Container(
                  color: Colors.white,
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: (Colors.grey[200])!,
                          blurRadius: 4,
                          offset: Offset(4, 4), // Shadow position
                        ),
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("No",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Nama",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Nomor",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Whatsapp",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Status",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text("Aksi",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () {
                        resources();
                        return Future.value('');
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: bloc.filter().length,
                          itemBuilder: (context, index) {
                            var d = bloc.filter()[index];
                            int oddEvent = index == 0 ? 0 : index % 2;
                            return GestureDetector(
                              onTap: d.status != '2'
                                  ? null
                                  : () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WithDraw(
                                                  id: d.id.toString(),
                                                  qty: d.qty.toString(),
                                                  name: d.name.toString(),
                                                  number:
                                                      d.number.toString())));
                                    },
                              child: Container(
                                color: oddEvent == 0
                                    ? Colors.grey[50]
                                    : Colors.white,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(d.no ?? '-',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(d.name ?? '-',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      
                                      Expanded(
                                        flex: 2,
                                        // child: SingleChildScrollView(
                                        //   scrollDirection: Axis.horizontal,
                                          child: Column(
                                            children: [
                                              Text(d.number ?? '-',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(" (${d.qty}X)",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ),
                                      // ),
                                      SizedBox(width:4),
                                      Expanded(
                                        flex: 2,
                                        child: Text(d.phone ?? '-',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            d.status == '2'
                                                ? 'Lunas'
                                                : d.status == '1'
                                                    ? 'Pending'
                                                    : 'Belum Dibayar',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: d.status == '2'
                                                    ? Colors.green
                                                    : d.status == '1'
                                                        ? Colors.blue
                                                        : Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              onTap: () {
                                                Widget cancelButton =
                                                    ElevatedButton(
                                                  child: Text("Batal"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                                Widget continueButton =
                                                    TextButton(
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
                                                d.status == '2'
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => WithDraw(
                                                                id: d.id
                                                                    .toString(),
                                                                qty: d.qty
                                                                    .toString(),
                                                                name: d.name
                                                                    .toString(),
                                                                number: d.number
                                                                    .toString())))
                                                    : showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return alert;
                                                        },
                                                      );
                                              },
                                              child: d.status == '2'
                                                  ? Icon(Icons.chevron_right,
                                                      color: Colors.blue)
                                                  : Icon(Icons.delete_outlined,
                                                      color: Colors.red))),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ]),
                )
        ]),
      ),
    );
  }
}
