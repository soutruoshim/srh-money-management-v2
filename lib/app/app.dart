import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monsey/common/bloc/type_wallet/bloc_type_wallet.dart';
import 'package:monsey/common/constant/dark_mode.dart';
import 'package:monsey/common/route/route_generator.dart';
import 'package:monsey/feature/home/bloc/chart/chart_bloc.dart';
import 'package:monsey/feature/home/bloc/wallets/bloc_wallets.dart';
import 'package:monsey/feature/home/screen/home.dart';
import 'package:monsey/feature/onboarding/bloc/user/bloc_user.dart';
import 'package:monsey/feature/onboarding/screen/onboarding.dart';
import 'package:monsey/feature/transaction/bloc/transactions/bloc_transactions.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../common/bloc/categories/bloc_categories.dart';
import '../feature/onboarding/bloc/slider/bloc_slider.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: 'Main Navigator');

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String?> getToken() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    final String? token = await firebaseUser.getIdToken();
    return token;
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<SliderBloc>(
          create: (BuildContext context) => SliderBloc(),
        ),
        BlocProvider<WalletsBloc>(
          create: (BuildContext context) => WalletsBloc(),
        ),
        BlocProvider<TransactionsBloc>(
          create: (BuildContext context) => TransactionsBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc(),
        ),
        BlocProvider<CategoriesBloc>(
          create: (BuildContext context) => CategoriesBloc(),
        ),
        BlocProvider<TypesWalletBloc>(
          create: (BuildContext context) => TypesWalletBloc(),
        ),
        BlocProvider<ChartBloc>(
          create: (BuildContext context) => ChartBloc(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: '/',
        navigatorKey: navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        title: 'Monsey',
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        // darkTheme: darkMode,
        // themeMode: themeMode,
        builder: (context, child) => ResponsiveWrapper.builder(child,
            maxWidth: 1200,
            minWidth: 480,
            defaultScale: true,
            breakpoints: const [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ],
            background: Container(color: const Color(0xFFF5F5F5))),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          child: FutureBuilder<String?>(
            future: getToken(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(
                    child: CupertinoActivityIndicator(
                      animating: true,
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.data != null) {
                    return const Home();
                  } else {
                    return const OnBoarding();
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
