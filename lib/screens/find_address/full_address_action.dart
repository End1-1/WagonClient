import 'package:freezed_annotation/freezed_annotation.dart';

import 'full_address_state.dart';

part 'full_address_action.freezed.dart';

abstract class BlocAction {

}

@freezed
class BlocActionReady extends BlocAction with _$BlocActionReady {
  const factory BlocActionReady({required bool ready}) = _BlockActionReady;
}

//TransportPoints, SuggestItem
@freezed
class BlocActionSetList extends BlocAction with _$BlocActionSetList{
  const factory BlocActionSetList({required List<dynamic>? list, required AddressListMode mode}) = _BlocActionSetList;
}