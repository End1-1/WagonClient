abstract class MyAddressSelectState {}
class MyAddressSelectStateIdle extends MyAddressSelectState{}
class MyAddressSelectStateFilter extends MyAddressSelectState{}
class MyAddressSelectStateReady extends MyAddressSelectState{
  dynamic result;
  MyAddressSelectStateReady({required this.result});
}