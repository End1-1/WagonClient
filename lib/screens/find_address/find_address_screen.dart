import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:wagon_client/airports_metro.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/screens/find_address/address_favorites.dart';
import 'package:wagon_client/screens/find_address/address_inputs.dart';

import 'address_list_widget.dart';
import 'find_address_model.dart';
import 'full_address_bloc.dart';
import 'full_address_state.dart';

class FindAddressScreen extends StatelessWidget {
  final FindAddressModel _model = FindAddressModel();

  FindAddressScreen({super.key, required bool focusFrom}) {
    RouteHandler.routeHandler.makeCopyOfRoute();

    _model.addressFrom.text = RouteHandler.routeHandler.addressFrom();
    _model.addressFrom.selection = TextSelection.fromPosition(TextPosition(offset: _model.addressFrom.text.length));
    _model.addressTo.text = RouteHandler.routeHandler.addressTo().join(", ");
    _model.addressTo.selection = TextSelection.fromPosition(TextPosition(offset: _model.addressTo.text.length));
    _model.selectFrom = focusFrom;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FullAddressBloc>(
        create: (_) => FullAddressBloc(BlocStateIdle(false)),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: BlocListener<FullAddressBloc, BlocState>(
                listener: (context, state) {
              _model.ready = state.isReady;
              if (state is BlocStateData) {
                switch (state.mode) {
                  case AddressListMode.airports:
                  case AddressListMode.favorites:
                  case AddressListMode.metros:
                  case AddressListMode.railways:
                    _model.currentList = state.data?.cast<TransportPoint>();
                    _model.suggestList = null;
                    break;
                  case AddressListMode.suggestItem:
                    _model.suggestList = state.data?.cast<SuggestItem>();
                    _model.currentList = null;
                    break;
                }
              }
            }, child: SafeArea(child: BlocBuilder<FullAddressBloc, BlocState>(builder: (context, state) {
              return Column(
                children: [
                  AddressInputs(model: _model),
                  Divider(thickness: 1, color: Colors.black12),
                  Divider(height: 2, thickness: 2, color: Colors.transparent),
                  //AddressFavorites(model: _model),
                  //Divider(height: 4, thickness: 2, color: Colors.transparent),
                  // Divider(
                  //   thickness: 1,
                  // ),
                  AddressListWidget(model: _model),
                ],
              );
            })))));
  }
}
