import 'dart:convert';

import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/helper/env.dart';
import 'package:ddgrandmacau/helper/http_request.dart';
import 'package:ddgrandmacau/models/History.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HistoryProvider with ChangeNotifier {
  Map<String, String> _requestHeaders = Map();
  List<HistoryModel> listNumber = [];

  String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<HistoryModel> filter() {
    List<HistoryModel> _l = [];
    for (var d in listNumber) {
      _l.add(d);
    }
    return _l;
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

    String? credential = await dataStore.getDataString('credential');
    String? userId = await dataStore.getDataString('user_id');
    String periode = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _requestHeaders['Authorization'] = 'Bearer $credential';
    _requestHeaders['Accept'] = 'application/json';
    HttpCustom.get(
      '${Env.url}api/peserta?user_id=$userId&tanggal=$periode',
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

        for (var d in data['data']) {
          listNumber.add(
            HistoryModel(
              id: d['id'].toString(),
              no: d['no'].toString(),
              number: d['nomor'].toString(),
              name: d['nama'] ?? '-',
              phone: d['phone'].toString(),
              qty: d['jumlah'].toString(),
              status: d['status'].toString(),
              total: d['total'].toString(),
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
      '${Env.url}api/withdraw',
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
