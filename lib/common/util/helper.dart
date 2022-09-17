import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:monsey/feature/transaction/screen/handle_transaction.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../app/app.dart';
import '../../feature/onboarding/bloc/user/bloc_user.dart';
import '../constant/colors.dart';
import '../model/category_model.dart';
import '../model/chart_model.dart';
import '../model/wallet_model.dart';
import '../route/routes.dart';

String iconOthers =
    'https://user-images.githubusercontent.com/79369571/187518582-7df30d86-f9c0-481a-9b32-83561c4e2e66.png';

DateTime now = DateTime.now();

NumberFormat formatMoney(BuildContext context) {
  final String symbol =
      BlocProvider.of<UserBloc>(context).userModel?.currencySymbol ?? '\$';
  return NumberFormat.currency(
      locale: 'en',
      customPattern: '#,###',
      decimalDigits: symbol == '₫' ? 0 : 2);
}

String handleStyleMoney(BuildContext context, double balance, {String? type}) {
  final String symbol =
      BlocProvider.of<UserBloc>(context).userModel?.currencySymbol ?? '\$';
  return '${type != null ? (type != 'income' ? "-" : "") : ''} $symbol${balance < 1 && balance > 0 ? '0' : ''}${formatMoney(context).format(balance).substring(balance >= 0 ? 0 : 1)}';
}

String calculatorBalance(
    BuildContext context, double incomeBalance, double expenseBalance) {
  final totalBalance = incomeBalance - expenseBalance;
  final String symbol =
      BlocProvider.of<UserBloc>(context).userModel?.currencySymbol ?? '\$';
  return totalBalance == 0
      ? symbol == '₫'
          ? '${symbol}0'
          : '${symbol}0.00'
      : '${totalBalance > 0 ? "" : "-"}$symbol${formatMoney(context).format(totalBalance).substring(totalBalance > 0 ? 0 : 1)}';
}

int randomIndex(int lengthList) {
  final _random = Random();

  final int element = _random.nextInt(lengthList);
  return element;
}

bool isSameYear(DateTime date1, DateTime date2) {
  final dateFormat = DateFormat('yyyy');
  return dateFormat.format(date1) == dateFormat.format(date2);
}

bool isSameMonth(DateTime date1, DateTime date2) {
  final dateFormat = DateFormat('yyyy-MM');
  return dateFormat.format(date1) == dateFormat.format(date2);
}

bool isSameDay(DateTime date1, DateTime date2) {
  final dateFormat = DateFormat('yyyy-MM-dd');
  return dateFormat.format(date1) == dateFormat.format(date2);
}

bool checkPremium(DateTime? datePremium) {
  if (datePremium == null) {
    return false;
  } else {
    if (datePremium.isBefore(DateTime(now.year - 1, now.month, now.day))) {
      return false;
    } else {
      return true;
    }
  }
  // return false;
}

int daysInMonth(DateTime date) {
  final firstDayThisMonth = DateTime(date.year, date.month, date.day);
  final firstDayNextMonth = DateTime(firstDayThisMonth.year,
      firstDayThisMonth.month + 1, firstDayThisMonth.day);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}

String formatCurrency(int num, {int fractionDigits = 0}) {
  if (num > 0 && num < 99999) {
    return '${num.toStringAsFixed(fractionDigits)}';
  } else if (num > 99999 && num < 999999) {
    return '${(num / 1000).toStringAsFixed(fractionDigits)} K';
  } else if (num > 999999 && num < 999999999) {
    return '${(num / 1000000).toStringAsFixed(fractionDigits)} M';
  } else if (num > 999999999) {
    return '${(num / 1000000000).toStringAsFixed(fractionDigits)} B';
  } else {
    return num.toString();
  }
}

int handlePercent(ChartData data, double _balance) {
  final double percent = data.balance / _balance * 100;
  final int balanceTmp =
      percent > 0 && percent < 1 ? percent.ceil() : percent.floor();
  return balanceTmp;
}

int handleBalance(
    List<ChartData> dataPieChart, int index, double _balance, ChartData data) {
  int balanceTmp = handlePercent(data, _balance);
  final int balanceTmp0 =
      dataPieChart.length > 1 ? handlePercent(dataPieChart[0], _balance) : 0;
  final int balanceTmp1 =
      dataPieChart.length > 2 ? handlePercent(dataPieChart[1], _balance) : 0;
  final int balanceTmp2 =
      dataPieChart.length > 3 ? handlePercent(dataPieChart[2], _balance) : 0;

  if (dataPieChart.length == 2) {
    balanceTmp =
        (index == dataPieChart.length - 1) ? (100 - balanceTmp0) : balanceTmp;
  }
  if (dataPieChart.length == 3) {
    balanceTmp = (index == dataPieChart.length - 1)
        ? (100 - balanceTmp0 - balanceTmp1)
        : balanceTmp;
  }
  if (dataPieChart.length == 4) {
    balanceTmp = (index == dataPieChart.length - 1)
        ? (100 - balanceTmp0 - balanceTmp1 - balanceTmp2)
        : balanceTmp;
  }
  return balanceTmp;
}

List<ChartData> handleChartData(
    List<ChartData> dataPieChartTmp, bool isIncome) {
  dataPieChartTmp.sort((a, b) => b.balance.compareTo(a.balance));
  List<ChartData> dataPieChart = dataPieChartTmp;

  if (dataPieChart.length > 3) {
    dataPieChart = dataPieChartTmp.getRange(0, 3).toList();
    final ChartData otherData = ChartData(malachite,
        categoryModel: CategoryModel(
            name: 'Others',
            id: 100,
            icon: iconOthers,
            type: isIncome ? 'income' : 'expense'),
        balance: 0,
        // ignore: prefer_const_literals_to_create_immutables
        trans: []);
    for (int i = 3; i < dataPieChartTmp.length; i++) {
      otherData.balance += dataPieChartTmp[i].balance;
      otherData.trans.addAll(dataPieChartTmp[i].trans);
    }
    dataPieChart.add(otherData);
  }
  return dataPieChart;
}

/// Config notification
Future<void> createNotification({WalletModel? walletModel}) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('monsey_logo');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (payload) {
      if (walletModel != null) {
        navigatorKey.currentState!.pushNamed(Routes.handleTransaction,
            arguments: HandleTransaction(walletModel: walletModel));
      } else {
        navigatorKey.currentState!.pushNamed(Routes.home);
      }
    },
  );
}

Future<void> requestPermissions() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  if (Platform.isIOS || Platform.isMacOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    scheduleNotification(20, 30);
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation?.requestPermission();
    if (granted != null && granted) {
      scheduleNotification(20, 30);
    }
  }
}

Future<void> scheduleNotification(int hour, int minutes) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'Remind',
    'Add transaction',
    channelDescription: 'Do you want to add any transaction?',
  );
  const iOSPlatformChannelSpecifics = IOSNotificationDetails();
  const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  final offset = now.timeZoneOffset;
  await flutterLocalNotificationsPlugin.cancelAll();
  await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Remind',
      'Do you want to add any transaction in today?',
      tz.TZDateTime(tz.local, now.year, now.month, now.day,
          hour - offset.inHours, minutes, 00),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time);
}

/// Config IN APP Review
final InAppReview inAppReview = InAppReview.instance;
