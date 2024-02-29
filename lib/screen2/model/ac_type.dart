import 'package:flutter/services.dart';
import 'package:wagon_client/model/tr.dart';

class ACType {
  static const int act_taxi = 1;
  static const int act_renttax = 2;
  static const int act_eakulator = 3;
  static const int act_businescab = 4;
  static const int act_limuzin = 5;
  static const int act_avtobus = 6;
  static const int act_bernatar = 7;
  static const int act_stap_varord = 8;
  static const int act_vulkanacum = 9;

  final images = <int, String>{
    act_taxi:'ac_taxicab',
    act_renttax: 'ac_taxicab',
    act_eakulator: 'ac_eakulator',
    act_businescab: 'ac_biznescab',
    act_limuzin: 'ac_limuzin',
    act_avtobus: 'ac_avtobus',
    act_bernatar: 'ac_bernatar',
    act_stap_varord: 'ac_stap_varord',
    act_vulkanacum: 'ac_vulkanacum',
  };

  final names = <int, String> {
    act_taxi: tr(trTaxCab),
    act_renttax: tr(trRentTaxi),
    act_eakulator: tr(trEakulator),
    act_businescab: tr(trBuzinesCab),
    act_limuzin: tr(trLimuzin),
    act_avtobus: tr(trAvtobus),
    act_bernatar: tr(trBernatar),
    act_stap_varord: tr(trStapVarord),
    act_vulkanacum: tr(trVulkanacum)
  };

  String imageName(int t) {
    return images[t]!;
  }

  String typeName(int t) {
    return names[t]!;
  }
}