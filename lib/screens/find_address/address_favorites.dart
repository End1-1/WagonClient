import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'find_address_model.dart';
import 'full_address_action.dart';
import 'full_address_bloc.dart';
import 'full_address_state.dart';

class AddressFavorites extends StatelessWidget {
  final FindAddressModel model;

  AddressFavorites({required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FullAddressBloc, BlocState>(
      buildWhen: (previous, current) => current is BlocStateData,
        builder: (context, state) {
          return Container(
            height: 60,
            child:  ListView(scrollDirection: Axis.horizontal, children: [
                VerticalDivider(width: 5, color: Colors.transparent),
                Container(
                    width: 100,
                    child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<FullAddressBloc>(context).actionToState(BlocActionSetList(
                              list: null, mode: AddressListMode.suggestItem));
                          // setState(() {
                          //  model.currentList = null;
                          // });
                        },
                        child: Column(children: [
                          Image.asset(
                            model.currentList == null
                                ? "images/placeholderlighta.png"
                                : "images/placeholderlight.png",
                            height: 40,
                            width: 40,
                          ),
                          Text(
                            "Адресa",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ]))),
                VerticalDivider(width: 5, color: Colors.black26),
                Container(
                    width: 100,
                    child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<FullAddressBloc>(context).actionToState(BlocActionSetList(
                              list: model.transportFavorites.favorites,
                              mode: AddressListMode.favorites));
                          // setState(() {
                          //  model.currentList =model.transportFavorites.favorites;
                          // });
                        },
                        child: Column(children: [
                          Image.asset(
                            state is BlocStateData && state.mode == AddressListMode.favorites
                                ? "images/heart1.png"
                                : "images/heart0.png",
                            height: 40,
                            width: 40,
                          ),
                          Text(
                            "Избранное",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ]))),
                VerticalDivider(width: 5, color: Colors.black26),
                Container(
                    width: 100,
                    child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<FullAddressBloc>(context).actionToState(BlocActionSetList(
                              list: model.transportPoints.metros,
                              mode: AddressListMode.metros));
                          // setState(() {
                          //  model.currentList =model.transportPoints.metros;
                          // });
                        },
                        child: Column(children: [
                          Image.asset(
                            state is BlocStateData && state.mode == AddressListMode.metros
                                ? "images/metroa.png"
                                : "images/metro.png",
                            height: 40,
                            width: 40,
                          ),
                          Text(
                            "Метро",
                            textAlign: TextAlign.center,
                          ),
                        ]))),
                VerticalDivider(width: 5, color: Colors.black26),
                Container(
                    width: 100,
                    child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<FullAddressBloc>(context).actionToState(BlocActionSetList(
                              list: model.transportPoints.railways,
                              mode: AddressListMode.railways));
                          // setState(() {
                          //  model.currentList =model.transportPoints.railways;
                          // });
                        },
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Image.asset(
                              state is BlocStateData && state.mode == AddressListMode.railways
                                  ? "images/railwaya.png"
                                  : "images/railway.png",
                              height: 40,
                              width: 40,
                            ),
                            Text(
                              "Вокзалы",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ))),
                VerticalDivider(width: 5, color: Colors.black26),
                Container(
                    width: 100,
                    child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<FullAddressBloc>(context).actionToState(BlocActionSetList(
                              list: model.transportPoints.airports,
                              mode: AddressListMode.airports));
                          // setState(() {
                          //  model.currentList =model.transportPoints.airports;
                          // });
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              state is BlocStateData && state.mode == AddressListMode.airports
                                  ? "images/airporta.png"
                                  : "images/airport.png",
                              height: 40,
                              width: 40,
                            ),
                            Text(
                              "Аэропорты",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ))),
              ]));
            });
  }
}
