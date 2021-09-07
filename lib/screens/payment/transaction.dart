import 'dart:convert';
import 'dart:io';

import 'package:ddgrandmacau/provider/TransactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ListTransaction extends StatefulWidget {
  const ListTransaction({Key? key}) : super(key: key);

  @override
  _ListTransactionState createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {
  bool isLoading = false, isError = false, isSendRequest = false;
  String errorMessage = '';
  final ImagePicker _picker = ImagePicker();
  // String pathImage = 'Kosong';
  PickedFile? pickedFile;

   bool simpan(trxId) {
    EasyLoading.show(status: 'loading...');
    TransactionProvider blocX = context.read<TransactionProvider>();
    Map form = Map();
    Map pathForm = Map();
    
      pathForm.addAll(
        {
          'bukti_trf': pickedFile!.path
        });
    // print(totalPay);
    form.addAll({
      'trx_id': trxId,
    });
  
    blocX.simpan(
      context,
      form: form,
      listPath: pathForm,
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

  void resources() {
    TransactionProvider blocX = context.read<TransactionProvider>();

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

  showAlertDialog(BuildContext context,nota) async {
    pickedFile = null;
    // set up the button
    Widget okButton = ElevatedButton(
     child:Text("Simpan"),
          
      onPressed: () {
        simpan(nota);
        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Unggah Bukti Pembayaran"),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                child: Text("Pilih File"),
                onPressed: () async {
                  PickedFile? _pickedFile =
                      await _picker.getImage(source: ImageSource.gallery);
                  setState(() {
                    pickedFile = _pickedFile;
                  });
                },
              ),
            ),
            pickedFile != null
                ? AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Card(
                        elevation: 3.0,
                        child: Image.file(File(pickedFile!.path),
                            width: 150, fit: BoxFit.fill)))
                : Container(),
          ],
        );
      }),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return alert;
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
    TransactionProvider bloc = Provider.of<TransactionProvider>(context);
    return Scaffold(
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
            child: bloc.listNumber.length < 1
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
                        itemCount: bloc.listNumber.length,
                        itemBuilder: (context, index) {
                          var d = bloc.filter()[index];
                          return Card(
                              elevation: 0,
                              child: ListTile(
                                onTap: d.note != 'Pending'? null :() {
                                  showAlertDialog(context,d.id);
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.chevron_right,
                                      color: Colors.blue),
                                  onPressed: () => {},
                                ),
                                title: Text(d.id ?? '-'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(d.total ?? '-'),
                                    Text(d.note ?? '-',
                                        style: TextStyle(
                                            color: d.note != 'Pending' ? Colors.green:Colors.red,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Center(
                                      child: Icon(Icons.credit_card,
                                          color: Colors.blue)),
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
