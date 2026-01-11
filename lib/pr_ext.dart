import 'package:flutter/material.dart';

/**
 * Created by Dmitry Diachenko on Feb 18, 2020
 * powered by leaditteam.com
 **/

extension StringExt on String {
  String trimSpaceAndLCase() {
    String _ = this
        .split(" ")
        .join("")
        .replaceAll(RegExp("[-=()*&^%#@!`~/:,.]"), "")
        .toLowerCase();
    return _;
  }
}

//MARK: widget ext
extension WidgetExtension on Widget {
  Widget expand() {
    return Expanded(child: this);
  }

  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget paddingOnly(
      {double left = 0, double right = 0, double top = 0, double bottom = 0}) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          left: left != 0 ? left : 0,
          right: right != 0 ? right : 0,
          top: top != 0 ? top : 0,
          bottom: bottom != 0 ? bottom : 0,
        ),
        child: this,
      ),
    );
  }

  Widget addOnTap({required Function()? onTap, Function()? onLongPress}) {
    return GestureDetector(
      child: Container(child: this),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  Widget insideScroll() {
    return SingleChildScrollView(child: this);
  }

  Widget insideScrollAndExpand() {
    return Expanded(child: SingleChildScrollView(child: this));
  }
}

//MARK : future   /-native_progress_hud: ^1.0.3
//extension MyFuture<T> on Future<T> {
//  Future<T> withProgressBar({BuildContext context}) async {
//    // show hud
//    var res;
//    Future.delayed(Duration(seconds: 8), () => NativeProgressHud.hideWaiting());
//    try {
//      NativeProgressHud.showWaiting();
//      res = await this;
//    } catch (e) {
//      developer.log(e);
//    } finally {
//      Future.delayed(Duration(seconds: 1),
//          () => NativeProgressHud.hideWaiting()); //for visibility
//    }
//    return res;
//  }
//}

//extension HexColor on Color {
//  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
//  static Color fromHex(String hexString) {
//    final buffer = StringBuffer();
//    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
//    buffer.write(hexString.replaceFirst('#', ''));
//    return Color(int.parse(buffer.toString(), radix: 16));
//  }
//
//  Color hexToColor(String code) {
//    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
//  }
//
//  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
//  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
//      '${alpha.toRadixString(16).padLeft(2, '0')}'
//      '${red.toRadixString(16).padLeft(2, '0')}'
//      '${green.toRadixString(16).padLeft(2, '0')}'
//      '${blue.toRadixString(16).padLeft(2, '0')}';
//}
class HexColor extends Color {
  HexColor(String hexString) : super(parseColor(hexString));

  static int parseColor(String color) {
    try {
      color = color.toUpperCase().replaceAll("#", "");
      if (color.length == 6) {
        color = "FF" + color;
      }
    } on Exception {
      return 0xFFFFFFFF; // Colors.white.value
    }
    return int.parse(color, radix: 16);
  }
}
