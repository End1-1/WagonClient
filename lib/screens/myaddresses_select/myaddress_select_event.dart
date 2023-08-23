abstract class MyAddressSelectEvent {}
class MyAddressSelectEventFilter extends MyAddressSelectEvent{}
class MyAddressSelectEventReady extends MyAddressSelectEvent{
  dynamic result;
  MyAddressSelectEventReady({required this.result});
}