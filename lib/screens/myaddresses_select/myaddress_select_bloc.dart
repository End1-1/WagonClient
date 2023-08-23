import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wagon_client/screens/myaddresses_select/myaddress_select_event.dart';

import 'myaddress_select_state.dart';

class MyAddressSelectBloc extends Bloc<MyAddressSelectEvent, MyAddressSelectState> {
  MyAddressSelectBloc(super.initialState) {
    on<MyAddressSelectEventFilter>((event, emit) => emit(MyAddressSelectStateFilter()));
    on<MyAddressSelectEventReady>((event, emit) => emit(MyAddressSelectStateReady(result: event.result)));
  }

}