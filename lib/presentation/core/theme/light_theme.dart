
import 'package:crane_monitoring_app/presentation/core/theme/color_utils.dart';
import 'package:flutter/material.dart';

const canvasColor = Color(0xffFFFFFF);

const primaryColor = Color(0xff7C987F);
const onPrimary = Colors.black;
final primaryColorLight = colorShiftLightness(primaryColor, 1.2);
final primaryColorDark = colorShiftLightness(primaryColor, 0.6);

const secondary = Color(0xff5D7E5F); // colorShiftLightness(canvasColor, 0.8); //Color(0xff269926);// Color(0xff242527);
const onSecondary = Color(0xff242527);

const tertiary = Color(0xff98BBFF);
const onTertiary = Color(0xff3B3B3B);

const surfaceColor = Color(0xffEEF1EF);  //Colors.amberAccent[400]!;
const onSurfaceColor = Colors.black;


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
final onBackgroundColor = colorInvert(backgroundColor);
const dialogBackgroundColor = canvasColor;
const indicatorColor = Colors.white;
const hintColor = Colors.white;
const errorColor = Color(0xffC0686D); //Colors.redAccent[700]!;
final onErrorColor = colorInvert(backgroundColor);
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
