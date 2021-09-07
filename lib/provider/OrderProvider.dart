import 'dart:convert';

import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/helper/env.dart';
import 'package:ddgrandmacau/helper/http_request.dart';
import 'package:ddgrandmacau/models/History.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class OrderProvider with ChangeNotifier {
  Map<String, String> _requestHeaders = Map();
  List<HistoryModel> listNumber = [];
  int price = 0;
  int totalQty = 0;
  int subtotalPayment = 0;
  String paymentImage = '-';
  String paymentName = '-';
  String paymentAccountNumber = '-';
  String paymentBankId = '';
  String paymentAccountName = '-';

  String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<HistoryModel> filter() {
    List<HistoryModel> _l = [];
    

    for (var d in listNumber) {
      
      _l.add(d);
    }
    return _l;
  }

  void getDataPayment(
    BuildContext context, {
    Function? onBeforeSend,
    Function? onComplete,
    Function(String)? onErrorCatch,
    Function(int, String)? onUnknownStatusCode,
    Function? onErrorAuthorization,
  }) async {
    DataStore dataStore = DataStore();

    String? credential = await dataStore.getDataString('credential');

    _requestHeaders['Authorization'] = 'Bearer $credential';
    _requestHeaders['Accept'] = 'application/json';
    HttpCustom.get(
      '${Env.url}api/metode-bayar',
      headers: _requestHeaders,
      onBeforeSend: () {
        onBeforeSend!();
      },
      onComplete: () {
        onComplete!();
      },
      onErrorAuthorization: () {
        onErrorAuthorization!();
      },
      onErrorCatch: (ini) {
        onErrorCatch!(ini);
      },
      onUnknownStatusCode: (kode, text) {
        onUnknownStatusCode!(kode, text);
      },
      onSuccess: (ini) {
        listNumber.clear();

        var data = jsonDecode(ini);
        paymentImage = data['data']['image'];
        paymentName = data['data']['nama_bank'];
        paymentAccountNumber = data['data']['norek'];
        paymentBankId = data['data']['bank_id'];
        paymentAccountName = data['data']['atas_nama'];
        notifyListeners();
      },
    );
  }

 void getPrice() async {
    DataStore dataStore = DataStore();

    String? credential = await dataStore.getDataString('credential');
    _requestHeaders['Authorization'] = 'Bearer $credential';
    _requestHeaders['Accept'] = 'application/json';
    HttpCustom.get(
      '${Env.url}api/getHarga',
      headers: _requestHeaders,
      onBeforeSend: () {
        
      },
      onComplete: () {
        
      },
      onErrorAuthorization: () {
        
      },
      onErrorCatch: (ini) {
        
      },
      onUnknownStatusCode: (kode, text) {
        
      },
      onSuccess: (ini) {
        var data = jsonDecode(ini);
        int _price = int.parse(data['data']['harga']);
        
        price = _price;
        notifyListeners();
      },
    );
  }

  void resource(
    BuildContext context, {
    Function? onBeforeSend,
    Function? onComplete,
    Function(String)? onErrorCatch,
    Function(int, String)? onUnknownStatusCode,
    Function? onErrorAuthorization,
  }) async {
    DataStore dataStore = DataStore();
   totalQty = 0;
   subtotalPayment = 0;
    String? credential = await dataStore.getDataString('credential');
    String? userId = await dataStore.getDataString('user_id');

    _requestHeaders['Authorization'] = 'Bearer $credential';
    _requestHeaders['Accept'] = 'application/json';
    HttpCustom.get(
      '${Env.url}api/peserta?user_id=$userId&tanggal=$dateNow&status=0',
      headers: _requestHeaders,
      onBeforeSend: () {
        onBeforeSend!();
      },
      onComplete: () {
        onComplete!();
        getPrice();
      },
      onErrorAuthorization: () {
        onErrorAuthorization!();
      },
      onErrorCatch: (ini) {
        onErrorCatch!(ini);
      },
      onUnknownStatusCode: (kode, text) {
        onUnknownStatusCode!(kode, text);
      },
      onSuccess: (ini) {
        listNumber.clear();

        var data = jsonDecode(ini);
        for (var d in data['data']) {
        subtotalPayment += int.parse(d['total'].toString());
          print(int.parse(d['total'].toString()));
          totalQty += int.parse(d['jumlah'].toString());
          listNumber.add(
            HistoryModel(
              id: d['id'].toString(),
              no: d['no'].toString(),
              number: d['nomor'].toString(),
              name: d['nama'] ?? '-',
              phone: d['phone'].toString(),
              qty: d['jumlah'].toString(),
            ),
          );
        }

        notifyListeners();
      },
    );
  }

  void simpan(
    BuildContext context, {
    Map? form,
    Function(String)? onSuccess,
    Function? onBeforeSend,
    Function? onComplete,
  }) async {
    DataStore store = DataStore();
    String? token = await store.getDataString('credential');

    _requestHeaders['Authorization'] = 'Bearer $token';
    _requestHeaders['Accept'] = 'application/json';

    HttpCustom.post(
      '${Env.url}api/peserta',
      headers: _requestHeaders,
      body: form,
      onBeforeSend: () {
        onBeforeSend!();
      },
      onComplete: () {
        onComplete!();
      },
      onSuccess: (ini) {
        onSuccess!(ini);
      },
      onErrorAuthorization: () {
        Fluttertoast.showToast(
          msg: 'Token kedaluwarsa, silahkan login kembali',
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
      onErrorCatch: (ini) {
        Fluttertoast.showToast(
          msg: ini,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
      onUnknownStatusCode: (kode, text) {
        Fluttertoast.showToast(
          msg: 'Error Code : $kode,\r$text',
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
    );
  }

   void delete(
    BuildContext context, {
    Map? form,
    Function(String)? onSuccess,
    Function? onBeforeSend,
    Function? onComplete,
  }) async {
    DataStore store = DataStore();
    String? token = await store.getDataString('credential');

    _requestHeaders['Authorization'] = 'Bearer $token';
    _requestHeaders['Accept'] = 'application/json';

    HttpCustom.post(
      '${Env.url}api/peserta/delete',
      headers: _requestHeaders,
      body: form,
      onBeforeSend: () {
        onBeforeSend!();
      },
      onComplete: () {
        onComplete!();
      },
      onSuccess: (ini) {
        onSuccess!(ini);
      },
      onErrorAuthorization: () {
        Fluttertoast.showToast(
          msg: 'Token kedaluwarsa, silahkan login kembali',
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
      onErrorCatch: (ini) {
        Fluttertoast.showToast(
          msg: ini,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
      onUnknownStatusCode: (kode, text) {
        Fluttertoast.showToast(
          msg: 'Error Code : $kode,\r$text',
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
    );
  }

  void bayar(
    BuildContext context, {
    Map? form,
    Function(String)? onSuccess,
    Function? onBeforeSend,
    Function? onComplete,
  }) async {
    DataStore store = DataStore();
    String? token = await store.getDataString('credential');

    _requestHeaders['Authorization'] = 'Bearer $token';
    _requestHeaders['Accept'] = 'application/json';

    HttpCustom.post(
      '${Env.url}api/bayar',
      headers: _requestHeaders,
      body: form,
      onBeforeSend: () {
        onBeforeSend!();
      },
      onComplete: () {
        onComplete!();
      },
      onSuccess: (ini) {
        onSuccess!(ini);
      },
      onErrorAuthorization: () {
        Fluttertoast.showToast(
          msg: 'Token kedaluwarsa, silahkan login kembali',
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
      onErrorCatch: (ini) {
        Fluttertoast.showToast(
          msg: ini,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
      onUnknownStatusCode: (kode, text) {
        Fluttertoast.showToast(
          msg: 'Error Code : $kode,\r$text',
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
    );
  }
}
