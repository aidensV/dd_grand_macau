import 'dart:convert';

import 'package:ddgrandmacau/helper/datastore.dart';
import 'package:ddgrandmacau/helper/env.dart';
import 'package:ddgrandmacau/helper/http_request.dart';
import 'package:ddgrandmacau/models/About.dart';
import 'package:ddgrandmacau/models/NumbersComeOut.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HomeProvider with ChangeNotifier {
  Map<String, String> _requestHeaders = Map();
  List<NumbersComeOut> listNumber = [];
  List<AboutModel> listAbout = [];
  List<BannerModel> listBanner = [];
  String numberOfWInner = '0';
  String dateOfWInner = '0';
  List<NumbersComeOut> filter() {
    List<NumbersComeOut> _l = [];
    for (var d in listNumber) {
      _l.add(d);
    }
    return _l;
  }
  List<AboutModel> filterAbout() {
    List<AboutModel> _l = [];
    for (var d in listAbout) {
      _l.add(d);
    }
    return _l;
  }

  void resource(BuildContext context, {
    Function? onBeforeSend,
    Function? onComplete,
    Function(String)? onErrorCatch,
    Function(int, String)? onUnknownStatusCode,
    Function? onErrorAuthorization,
  }) async {
    DataStore dataStore = DataStore();
  
    String? credential = await dataStore.getDataString('credential');
    String periode = DateFormat('yyyy-MM').format(DateTime.now());

    _requestHeaders['Authorization'] = 'Bearer $credential';
    _requestHeaders['Accept'] = 'application/json';
     HttpCustom.get(
      '${Env.url}api/pemenang/history?bulan=$periode',
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
              NumbersComeOut(
                no: d['no'].toString(),
                date: d['tanggal'],
                number: d['nomor'].toString(),
              ),
            );
          }

        notifyListeners();
      },
    );

  }

   void about(
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
      '${Env.url}api/reward',
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
        listAbout.clear();

        var data = jsonDecode(ini);
  print(data);
        for (var d in data['data']) {
          listAbout.add(
            AboutModel(
              desc: d['desc'].toString(),
              no: d['no'].toString(),
              value: d['value'].toString(),
              
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
      '${Env.url}api/user-management/change-profil',
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


   void changePassword(
    BuildContext context, {
    Map? form,
    Function(String)? onSuccess,
    Function? onBeforeSend,
    Function? onComplete,
    Function? onErrorCatch,
  }) async {
    DataStore store = DataStore();
    String? token = await store.getDataString('credential');

    _requestHeaders['Authorization'] = 'Bearer $token';
    _requestHeaders['Accept'] = 'application/json';

    HttpCustom.get(
      '${Env.url}api/user-management/change-password',
      headers: _requestHeaders,
      params: form,
      
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
        onErrorCatch!(ini);
      },
      onUnknownStatusCode: (kode, text) {
        Fluttertoast.showToast(
          msg: 'Password lama tidak sama',
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      },
    );
  }

  void banner(BuildContext context, {
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
      '${Env.url}api/banner',
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
            listBanner.add(
              BannerModel(
                no: d['no'].toString(),
                url: d['url'].toString(),
              ),
            );
          }

        notifyListeners();
      },
    );

  }

  void winner(BuildContext context, {
    Function? onBeforeSend,
    Function? onComplete,
    Function(String)? onErrorCatch,
    Function(int, String)? onUnknownStatusCode,
    Function? onErrorAuthorization,
  }) async {
    DataStore dataStore = DataStore();
  
    String? credential = await dataStore.getDataString('credential');
String periode = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _requestHeaders['Authorization'] = 'Bearer $credential';
    _requestHeaders['Accept'] = 'application/json';
     HttpCustom.get(
      '${Env.url}api/pemenang?tanggal=$periode',
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
        var numberWinner = data['data'] != null ? data['data']['nomor'].toString() : '0000';
        var _dateWinner = data['data'] != null ? data['data']['tanggal'].toString() : DateFormat('yyyy-MM-dd').format(DateTime.now());
        numberOfWInner = numberWinner;
        dateOfWInner = _dateWinner;
        notifyListeners();
      },
    );

  }
}
