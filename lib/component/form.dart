import 'package:flutter/material.dart';

import '../common/theme.dart';

class BSText extends StatelessWidget {
  final String text;
  final String? weight;
  final double? size;
  final double? lineHeight;
  final Color? color;
  final String? align;
  final String? overflow;
  final int? maxLines;

  const BSText({
    super.key,
    required this.text,
    this.weight = 'normal',
    this.size = 14,
    this.lineHeight = 0,
    this.color = BSColor.gray10,
    this.align = '',
    this.overflow = '',
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final String fontFamily = weight == 'light'
        ? BSFont.light
        : weight == 'bold'
            ? BSFont.bold
            : BSFont.normal;
    return DefaultTextStyle(
        style: TextStyle(
            fontFamily: fontFamily,
            color: color,
            fontSize: size as double,
            height: lineHeight == 0 ? 1.2 : (lineHeight! / size!)),
        child: overflow == 'ellipsis'
            ? Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: maxLines,
                textAlign:
                    align == 'center' ? TextAlign.center : TextAlign.start,
              )
            : Text(
                text,
                textAlign:
                    align == 'center' ? TextAlign.center : TextAlign.start,
              ));
  }
}

class BSButton extends StatelessWidget {
  final Function()? onTap;
  final String? text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final String? textWeight;
  final bool? round;
  final bool? boxShadow;
  final String? size;

  const BSButton({
    Key? key,
    required this.onTap,
    this.text = '',
    this.icon,
    this.backgroundColor = BSColor.gray2,
    this.textColor = BSColor.gray8,
    this.round = false,
    this.boxShadow = false,
    this.textWeight = '',
    this.size = 'm',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = (size == 's')
        ? 26
        : (size == 'sm')
            ? 40
            : (size == 'l')
                ? 56
                : 48;
    return Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: round == true
                ? BorderRadius.circular(120)
                : BorderRadius.circular(size == 's' ? 6 : 12),
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: BSColor.gray10.withOpacity(boxShadow == true ? 0.04 : 0),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 1),
              )
            ]),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: round == true
                  ? BorderRadius.circular(120)
                  : BorderRadius.circular(size == 's' ? 6 : 12),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: size == 'sm' ? 20 : 8),
                alignment: Alignment.center,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icon, size: icon != null ? 24 : 0, color: textColor),
                  SizedBox(
                      width: text != '' && icon != null ? 10 : 0,
                      height: text != '' && icon != null ? 10 : 0),
                  BSText(
                    text: text!,
                    size: text != ''
                        ? size == 'sm'
                            ? 14
                            : size == 's'
                                ? 12
                                : 16
                        : 0,
                    lineHeight: text != ''
                        ? size == 'sm'
                            ? 18
                            : size == 's'
                                ? 14
                                : 20
                        : 0,
                    weight: textWeight,
                    color: textColor,
                  ),
                ]),
              ),
            )));
  }
}
