import 'dart:io';
import 'package:http/http.dart' as http;

class HttpCustom {
  // HttpRequest._internal();

  // static final HttpRequest _initialize = HttpRequest._internal();

  // static HttpRequest get initialize => _initialize;

  /// # Send Request Tipe POST
  ///
  /// [url] = nama url.
  ///
  /// [body] = send request.
  ///
  /// [params] = params send request.
  ///
  /// [headers] = headers send request.
  ///
  /// [onBeforeSend] = sebelum melakukan send request.
  ///
  /// [onComplete] = ketika selesai melakukan send request.
  ///
  /// [onUnknownStatusCode] <kodeAngka, pesan> = ketika selesai send request status tidak diketahui.
  ///
  /// [onErrorCatch] = ketika terjadi error di `try {} catch {}.
  ///
  /// [onSuccess] = ketika selesai send request status 200.
  ///
  /// [listFilePath] = list file path
  static void post(
    String url, {
    Map? body,
    Map<String,String>? headers,
    Function? onBeforeSend,
    Function? onComplete,
    Function(int, String)? onUnknownStatusCode,
    Function()? onErrorAuthorization,
    Function(String)? onErrorCatch,
    Function(String)? onSuccess,
    Map? listFilePath,
  }) async {
    onBeforeSend!();
    try {
      if (listFilePath != null) {
        print("MULTIPAT");
        var req = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );

        Map<String, String> mapX = Map<String, String>.from(listFilePath);

        List<String> listKeys = mapX.keys.toList();
        List<String> listValue = mapX.values.toList();
        
        req.headers.addAll(headers!);

        req.fields.addAll(Map<String, String>.from(body!));

        for (int i = 0; i < listKeys.length; i++) {
          var k = listKeys[i];
          var v = listValue[i];

          req.files.add(await http.MultipartFile.fromPath(k, v));
        }

        var response = await req.send();

        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print("RESPON $responseString");
        if (response.statusCode == 200) {
          onSuccess!(responseString);
        } else if (response.statusCode == 401) {
          onErrorAuthorization!();
        } else {
          onUnknownStatusCode!(response.statusCode, responseString);
        }
      } else {
        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );
        print('result ${response.body}');
        if (response.statusCode == 200) {
          onSuccess!(response.body);
        } else if (response.statusCode == 401) {
          onErrorAuthorization!();
        } else {
          onUnknownStatusCode!(response.statusCode, response.body);
        }
      }
      onComplete!();
    } on SocketException {
      onErrorCatch!('Request Timeout, silahkan coba kembali');
      onComplete!();
    } catch (e) {
      print(e);
      onErrorCatch!(e.toString());
      onComplete!();
    }
  }

  /// # Send Request Tipe GET
  ///
  /// [url] = nama url.
  ///
  /// [params] = params send request.
  ///
  /// [headers] = headers send request.
  ///
  /// [onBeforeSend] = sebelum melakukan send request.
  ///
  /// [onComplete] = ketika selesai melakukan send request.
  ///
  /// [onErrorAuthorization] = ketika selesai send request status un authorization.
  ///
  /// [onUnknownStatusCode] <kodeAngka, pesan> = ketika selesai send request status tidak diketahui.
  ///
  /// [onErrorCatch] = ketika terjadi error di `try {} catch {}.`
  ///
  ///
  /// [onSuccess] = ketika selesai send request status 200.
  static void get(
    String url, {
    Map? params,
    Map<String, String>? headers,
    Function? onBeforeSend,
    Function? onComplete,
    Function(int, String)? onUnknownStatusCode,
    Function()? onErrorAuthorization,
    Function(String)? onErrorCatch,
    Function(String)? onSuccess,
  }) async {
    onBeforeSend!();
    try {
      /// membuat @params untuk send request tipe GET
      String parameter = _convertParams(params);
      print(parameter);

      final response = await http.get(
        Uri.parse('$url$parameter'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        onSuccess!(response.body);
      } else if (response.statusCode == 401) {
        onErrorAuthorization!();
      } else {
        onUnknownStatusCode!(response.statusCode, response.body);
      }
      onComplete!();
    } on SocketException catch (_) {
      onErrorCatch!(
          'Request timed out, please check your connection and try again');
      onComplete!();
    } catch (e) {
      print(e);
      onErrorCatch!(e.toString());
      onComplete!();
    }
  }

  static String _convertParams(params) {
    String result = '';
    if (params != null) {
      for (int i = 0; i < params.keys.toList().length; i++) {
        var key = params.keys.toList()[i];
        var value = params.values.toList()[i];
        if (i == 0) {
          result += '?$key=$value';
        } else {
          result += '&$key=$value';
        }
      }
    }
    return result;
  }
}
