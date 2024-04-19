import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/screens/find_address/find_address_model.dart';
import 'package:wagon_client/screens/find_address/full_address_action.dart';
import 'package:wagon_client/screens/find_address/full_address_bloc.dart';
import 'package:wagon_client/web/yandex_geocode.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

import '../../airports_metro.dart';
import '../../suggest_address_widget.dart';

class AddressListWidget extends StatefulWidget {
  final FindAddressModel model;

  AddressListWidget({required this.model});

  @override
  State<StatefulWidget> createState() => _AddressListWidget();
}

class _AddressListWidget extends State<AddressListWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.model.currentList != null
        ? Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.model.currentList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return SuggestAddressWidget(
                      shortAddress: widget.model.currentList![index].name,
                      fullAddress: widget.model.currentList![index].address,
                      tapCallback: () {
                        _addressTap(index);
                      },
                      tp: widget.model.currentList![index].tp);
                }))
        : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.model.suggestList?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return SuggestAddressWidget(
                    shortAddress: widget.model.suggestList![index].title,
                    fullAddress: widget.model.suggestList![index].subtitle ?? '',
                    tapCallback: () {
                      _addressTap(index);
                    },
                  );
                }));
  }

  void _addressTap(int index) async {
    if (widget.model.currentList == null) {
      _useAddress(index);
    } else {
      _useTransportPoints(index);
    }
  }

  void _useAddress(int index) async {
    ym.SuggestItem? item = widget.model.suggestList?.elementAt(index);
    if (item == null) {
      return;
    }
    late String searchText;
    switch (item.type) {
      case ym.SuggestItemType.business:
        searchText = item.subtitle ?? item.displayText;
        break;
      default:
        searchText = item.searchText;
        break;
    }

    if (widget.model.selectFrom) {
      RouteHandler.routeHandler.directionStruct.from = AddressStruct(address: searchText, title: item.title, point: null);
      widget.model.addressFrom.text = RouteHandler.routeHandler.addressFrom();
      widget.model.addressFrom.selection = TextSelection(baseOffset: widget.model.addressFrom.text.length, extentOffset: widget.model.addressFrom.text.length);
    } else {
      if (RouteHandler.routeHandler.directionStruct.to.isEmpty) {
        RouteHandler.routeHandler.directionStruct.to.add(AddressStruct(address: '', title: '', point: null));
      }
      RouteHandler.routeHandler.directionStruct.to.last = AddressStruct(address: searchText, title: item.title, point: null);
      widget.model.addressTo.text = RouteHandler.routeHandler.addressTo().join(",");
      widget.model.addressTo.selection = TextSelection(baseOffset: widget.model.addressTo.text.length, extentOffset: widget.model.addressTo.text.length);
    }


    setState(() {
      widget.model.suggestList = null;
      widget.model.ready = false;
    });

    final YandexGeocoder geocoder = YandexGeocoder(apiKey: Consts.yandexGeocodeKey);

    // final GeocodeResponse geocodeFromPoint = await geocoder.getGeocode(GeocodeRequest(
    //   geocode: PointGeocode(latitude: 55.771899, longitude: 37.597576),
    //   lang: Lang.enEn,
    // ));

    final GeocodeResponse geocodeFromAddress = await geocoder.getGeocode(DirectGeocodeRequest(
      addressGeocode: searchText)
    );

    ym.Point p = ym.Point(
        latitude: geocodeFromAddress.firstPoint?.lat ?? 0,
        longitude: geocodeFromAddress.firstPoint?.lon ?? 0);

      if (widget.model.selectFrom) {
        RouteHandler.routeHandler.directionStruct.from =
            RouteHandler.routeHandler.directionStruct.from.copyWith(
                point: p);
      } else {
        RouteHandler.routeHandler.directionStruct.to.last = RouteHandler.routeHandler.directionStruct.to.last.copyWith(point: p);
      }
      widget.model.ready = true;
      BlocProvider.of<FullAddressBloc>(context).actionToState(
          BlocActionReady(ready: true));

  }

  void _useTransportPoints(int index) async {
    TransportPoint tp = widget.model.currentList![index];
    if (widget.model.selectFrom) {
      RouteHandler.routeHandler.directionStruct.from = AddressStruct(address: tp.address ?? '', title: tp.name ?? '',  point: ym.Point(latitude: tp.cord.lat, longitude: tp.cord.lon));
      widget.model.addressFrom.text = tp.address ?? '';
      widget.model.addressFrom.selection = TextSelection.fromPosition( TextPosition(offset: tp.address?.length ?? 0));
    } else {
      RouteHandler.routeHandler.directionStruct.to.last = AddressStruct(address: tp.address ?? '', title: tp.name ?? '',  point: ym.Point(latitude: tp.cord.lat, longitude: tp.cord.lon));
      widget.model.addressTo.text = tp.address ?? '';
      widget.model.addressTo.selection = TextSelection.fromPosition( TextPosition(offset: tp.address?.length ?? 0));
    }
  }
}
