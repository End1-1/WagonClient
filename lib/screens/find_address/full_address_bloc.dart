import 'package:flutter_bloc/flutter_bloc.dart';

import 'full_address_action.dart';
import 'full_address_state.dart';

class FullAddressBloc extends Bloc<BlocAction, BlocState> {
  FullAddressBloc(super.initialState);

  Future<void> actionToState(BlocAction a) async {
    emit(BlocStateIdle(false));
    if (a is BlocActionSetList) {
      emit(BlocStateData(data: a.list, mode: a.mode, isReady: false));
    } else if (a is BlocActionReady) {
      emit(BlocStateIdle(a.ready));
    }
  }
}