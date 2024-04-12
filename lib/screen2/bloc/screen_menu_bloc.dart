

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppAnimateStateIdle extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppAnimateStateRaise extends AppAnimateStateIdle{}

class AppAnimateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppAnimateEventRaise extends AppAnimateEvent {}


class AppAnimateBloc extends Bloc<AppAnimateEvent, AppAnimateStateIdle> {
  AppAnimateBloc() : super(AppAnimateStateIdle()) {
    on<AppAnimateEvent>((event, emit) => emit(AppAnimateStateIdle()));
    on<AppAnimateEventRaise>((event, emit) => emit(AppAnimateStateRaise()));
  }

}