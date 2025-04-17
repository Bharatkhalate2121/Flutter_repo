import "package:flutter/material.dart";
import "package:get/get.dart";

class ContextClass with ChangeNotifier {
  RxInt _inr = 0.obs;
  RxInt _usd = 0.obs;

  void set usd(RxInt usd) {
    this._usd.value = usd.value;
  }

  void convert() {
    _usd.value = 80 * _inr.value;
  }

  RxInt get usd => _usd;

  void set inr(RxInt inr) {
    this._inr.value = inr.value;
  }

  RxInt get inr => _inr;
}
