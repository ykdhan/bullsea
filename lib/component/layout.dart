import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/theme.dart';
import 'form.dart';

PreferredSizeWidget BSAppBar(
    {bool? sizeZero = false,
    Color? color = BSColor.gray0,
    Color? border = Colors.transparent,
    Widget? leading,
    bool? gradient = false,
    String? title = '',
    String? systemColor = 'dark'}) {
  final appbar = AppBar(
      backgroundColor: color,
      shadowColor: Colors.transparent,
      systemOverlayStyle: systemColor == 'dark'
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      leading: leading,
      title: BSText(
        text: title ?? '',
        size: 17,
        lineHeight: 20,
        weight: 'bold',
      ),
      flexibleSpace: gradient == false
          ? Container()
          : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  BSColor.gray10.withOpacity(0.4),
                  BSColor.gray10.withOpacity(0),
                ],
                begin: const FractionalOffset(0, 0),
                end: const FractionalOffset(0, 1),
                stops: const [0.0, 1.0],
              )),
            ),
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: border,
          )));
  return sizeZero == true
      ? PreferredSize(preferredSize: const Size.fromHeight(0), child: appbar)
      : appbar;
}
