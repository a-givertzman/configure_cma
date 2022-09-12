
import 'package:configure_cma/presentation/core/theme/color_utils.dart';
import 'package:flutter/material.dart';

const canvasColor = Color(0xff313131);

const primaryColor = Color(0xff91B4F8);
const onPrimary = Color(0xff242527);
final primaryColorLight = colorShiftLightness(primaryColor, 1.2);
final primaryColorDark = colorShiftLightness(primaryColor, 0.6);

final secondary = Color(0xffC3ABF8);
const onSecondary = Color(0xff242527);

const tertiary = Color(0xffB0B1AC);
const onTertiary = Color(0xff2B2B2B);

const surfaceColor = Color(0xff3b3b3b);
const onSurfaceColor = Colors.white;

const focusColor = Colors.white;
const hoverColor = Colors.white;

final shadowColor = colorShiftLightness(canvasColor, 0.2).withOpacity(0.3);

const scaffoldBackgroundColor = canvasColor;
const bottomAppBarColor = Colors.white;
const cardColor = surfaceColor;
const dividerColor = Colors.white;
const highlightColor = Colors.white;
const splashColor = Colors.white;
const selectedRowColor = Colors.white;
const unselectedWidgetColor = Colors.white;
const disabledColor = Colors.white;
const secondaryHeaderColor = Colors.white;
const backgroundColor = canvasColor;
const onBackgroundColor = Colors.white;
const dialogBackgroundColor = canvasColor;
const indicatorColor = Colors.white;
const hintColor = Colors.white;
const errorColor = Color(0xffF9A880); //Colors.redAccent[700]!;
const onErrorColor = Colors.white;
const toggleableActiveColor = Colors.white;

const activeStateColor = Color(0xff84E4B7);
const passiveStateColor = backgroundColor;

const lowLevelColor = errorColor;
const highLevelColor = errorColor;
const obsoleteStatusColor = Colors.amber;
const invalidStatusColor = Colors.purple;
const timeInvalidStatusColor = Colors.purple;

const alarmClass1Color = Color(0xffF00505);
const alarmClass2Color = Color(0xffFF2C05);
const alarmClass3Color = Color(0xffFD6104);
const alarmClass4Color = Color(0xffFD9A01);
const alarmClass5Color = Color(0xffFFCE03);
const alarmClass6Color = Color(0xffFEF001);
