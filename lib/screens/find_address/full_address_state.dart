enum AddressListMode {suggestItem, favorites, metros, airports, railways}

abstract class BlocState {
  bool isReady;
  BlocState({required this.isReady});
}

class BlocStateIdle extends BlocState {
  BlocStateIdle(bool ready) : super(isReady: ready);
}

class BlocStateData extends BlocState {
  final List<dynamic>? data;
  final AddressListMode mode;
  BlocStateData({required this.data, required this.mode, required super.isReady});
}
