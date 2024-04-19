import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:http/src/response.dart';

import '../consts.dart';

enum HttpMethod { GET, POST, PUT, DELE }

class WebParent {
  String? _url;
  HttpMethod? method;

  int responseCode = -1;
  String? errorBody;

  dynamic body;

  WebParent(String? url, HttpMethod? m) {
    _url = url;
    method = m;
  }

  Future<void> request(Function done, Function? fail) async {
    final sw = Stopwatch()..start();
    var client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);
    print("URL: ${Consts.host()}$_url");
    try {
      print("BODY TRY: ${utf8.decode(getBody() ?? [])}");
    } catch (e) {
      print("BODY CATCH: ${getBody()}");
      print(e);
    }
    try {
      late Response response;
      switch (method) {
        case HttpMethod.GET:
          response = await ioClient.get(Uri.https(Consts.host(), _url!),
              headers: getHeader());
          break;
        case HttpMethod.POST:
        case HttpMethod.PUT:
          response = await ioClient.post(Uri.https(Consts.host(), getUrl()!),
              body: getBody(), headers: getHeader());
          break;
        case HttpMethod.DELE:
          response = await ioClient.delete(Uri.https(Consts.host(), getUrl()!),
              headers: getHeader());
          break;
        default:
          break;
      }
      sw.stop();
      print("Response time: ${sw.elapsed} length: ${response.body.length} " +
              response.statusCode.toString() +
              ": " +
              Consts.host() +
              _url! +
              ": " +
              response.body);
      responseCode = response.statusCode;
      if (responseCode < 299) {
        dynamic d = jsonDecode(response.body);
        done(d);
      } else {
        errorBody = response.body;
        throw (errorBody!);
      }
    } catch (e) {
      // if (!tester) {
      //   WebTester webTester = WebTester(getBody().toString(), getHeader().toString(), e.toString(), _url!, HttpMethod.POST);
      //   webTester.request(null, null);
      // }
      if (fail != null) {
        fail(responseCode, e.toString());
      }
      print(e.toString());
    } finally {
      client.close();
    }
  }

  dynamic getHeader() {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + Consts.getString("bearer")
    };
  }

  dynamic getBody() {
    return jsonEncode(body);
  }

  String? getUrl() {
    return _url;
  }
}
