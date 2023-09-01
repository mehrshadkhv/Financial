import 'package:flutter/material.dart';

extension ScreenSize on BuildContext{
  get screenWidth => MediaQuery.of(this).size.width;
  get screenHight => MediaQuery.of(this).size.height;

}