import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:monsey/common/bloc/categories/bloc_categories.dart';
import 'package:monsey/common/constant/images.dart';
import 'package:monsey/common/graphql/queries.dart';
import 'package:monsey/common/model/user_model.dart';
import 'package:monsey/common/util/helper.dart';
import 'package:monsey/feature/home/bloc/chart/chart_bloc.dart';
import 'package:monsey/feature/home/bloc/chart/chart_event.dart';
import 'package:monsey/feature/home/bloc/wallets/bloc_wallets.dart';

import '../../../common/bloc/type_wallet/bloc_type_wallet.dart';
import '../../../common/graphql/config.dart';
import '../../../common/graphql/subscription.dart';
import '../../onboarding/bloc/user/bloc_user.dart';
import '../../profile/screen/profile.dart';
import '../widget/home_widget.dart';
import 'dashboard.dart';
import 'statictis.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User firebaseUser = FirebaseAuth.instance.currentUser!;
  List<Widget> listWidget = [];
  int _currentIndex = 0;

  Future<void> listenWallets() async {
    final String token = await firebaseUser.getIdToken();
    Config.initializeClient(token)
        .value
        .subscribe(SubscriptionOptions(
            document: gql(Subscription.listenWallets),
            variables: <String, dynamic>{'user_uuid': firebaseUser.uid}))
        .listen((event) {
      if (event.data != null) {
        if (mounted) {
          context.read<WalletsBloc>().add(InitialWallets());
          context.read<ChartBloc>().add(const InitialChart(walletId: 0));
        }
      }
    });
  }

  Future<UserModel?> getUserInfo() async {
    UserModel? userModel;
    final String token = await firebaseUser.getIdToken();
    Config.initializeClient(token)
        .value
        .query(QueryOptions(
            document: gql(Queries.getUser),
            variables: <String, dynamic>{'uuid': firebaseUser.uid}))
        .then((value) {
      print(value);
      if (value.data!.isNotEmpty && value.data!['User'].length > 0) {
        userModel = UserModel.fromJson(value.data!['User'][0]);
        context.read<UserBloc>().add(GetUser(userModel!));
      }
    });
    return userModel;
  }

  @override
  void initState() {
    getUserInfo();
    listenWallets().whenComplete(() async {
      await createNotification(
          walletModel: context.read<WalletsBloc>().walletsTotal.isNotEmpty
              ? context.read<WalletsBloc>().walletsTotal[0]
              : null);
      await requestPermissions();
    });
    context.read<CategoriesBloc>().add(InitialCategories());
    context.read<TypesWalletBloc>().add(InitialTypesWallet());
    listWidget = [
      const Dashboard(),
      const Statictis(),
      const Profile(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    // FirebaseAuth.instance.currentUser!.delete();
    return Scaffold(
      body: listWidget.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
            if (_currentIndex == 1) {
              context
                  .read<ChartBloc>()
                  .add(ChangeTimeChart(walletId: 0, dateTime: now));
            }
          });
        },
        items: [
          createItemNav(context, icHome, icHomeActive, 'Dashboard'),
          createItemNav(context, icChart, icChartActive, 'Chart'),
          createItemNav(context, icAccount, icAccountActive, 'Account'),
        ],
      ),
    );
  }
}
