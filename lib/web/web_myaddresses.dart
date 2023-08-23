import 'package:sprintf/sprintf.dart';

import 'web_parent.dart';

enum AddressAction {
  GET,
  POST,
  PUT,
  DEL
}

class WebMyAddresses extends WebParent {

  int? id;
  String? name;
  String? country;
  String? address;
  double? latitude;
  double? longitude;
  AddressAction? action;

  WebMyAddresses({String? url, HttpMethod? method, this.action}) : super(url, method);

  static void getList(Function done, Function? fail) {
    WebMyAddresses myAddresses = WebMyAddresses(url: "/app/mobile/address", method: HttpMethod.GET, action: AddressAction.GET);
    myAddresses.request(done, fail);
  }

  static void create(String name, String country, String address, double latitude,  double longitude, Function done, Function? fail) {
    WebMyAddresses myAddresses = WebMyAddresses(url: "/app/mobile/address", method: HttpMethod.POST, action: AddressAction.POST);
    myAddresses.name = name;
    myAddresses.country = country;
    myAddresses.address = address;
    myAddresses.longitude = longitude;
    myAddresses.latitude = latitude;
    myAddresses.request(done, fail);
  }

  static void edit(int id, String name, String country, String address, double latitude,  double longitude, Function done, Function? fail) {
    WebMyAddresses myAddresses = WebMyAddresses(url: sprintf("/app/mobile/address/%d", [id]), method: HttpMethod.POST, action: AddressAction.PUT);
    myAddresses.id = id;
    myAddresses.name = name;
    myAddresses.country = country;
    myAddresses.address = address;
    myAddresses.longitude = longitude;
    myAddresses.latitude = latitude;
    myAddresses.request(done, fail);
  }

  static void remove(int id, Function done, Function? fail) {
    WebMyAddresses myAddresses = WebMyAddresses(url: sprintf("/app/mobile/address/%d", [id]), method: HttpMethod.DELE, action: AddressAction.DEL);
    myAddresses.request(done, fail);
  }

  @override
  dynamic getBody() {
    switch (action) {
      case AddressAction.GET:
        break;
      case AddressAction.POST:
        return {
          "name": name,
          "short_address": country,
          "address": address,
          "cord[lat]": sprintf("%f", [latitude]),
          "cord[lut]": sprintf("%f", [longitude]),
          "favorite": "false"
        };
      case AddressAction.PUT:
        return {
          "name": name,
          "short_address": country,
          "address": address,
          "cord[lat]": sprintf("%f", [latitude]),
          "cord[lut]": sprintf("%f", [longitude]),
          "favorite": "false",
          "_method": "PUT"
        };
      default:
        return {};
    }
  }
}