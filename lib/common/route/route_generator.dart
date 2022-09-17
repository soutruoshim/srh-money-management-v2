import 'package:flutter/material.dart';
import 'package:monsey/feature/home/screen/balance_wallet.dart';
import 'package:monsey/feature/home/screen/chart_analysis.dart';
import 'package:monsey/feature/home/screen/dashboard.dart';
import 'package:monsey/feature/home/screen/edit_wallet.dart';
import 'package:monsey/feature/home/screen/home.dart';
import 'package:monsey/feature/home/screen/name_wallet.dart';
import 'package:monsey/feature/home/screen/transactions_detail.dart';
import 'package:monsey/feature/home/screen/type_wallet.dart';
import 'package:monsey/feature/onboarding/screen/onboarding.dart';
import 'package:monsey/feature/profile/screen/premium.dart';
import 'package:monsey/feature/profile/screen/premium_successful.dart';
import 'package:monsey/feature/transaction/screen/expense_categories.dart';
import 'package:monsey/feature/transaction/screen/handle_transaction.dart';
import 'package:monsey/feature/transaction/screen/income_categories.dart';
import 'package:monsey/feature/transaction/screen/note_transaction.dart';
import 'package:monsey/feature/transaction/screen/select_wallet.dart';

import '../../feature/home/screen/create_wallet.dart';
import '../../feature/onboarding/widget/web_view_privacy.dart';
import '../../feature/profile/screen/currency_custom.dart';
import '../../feature/transaction/screen/transaction_full.dart';
import 'routes.dart';

mixin RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      // / route catalog onBoarding
      case Routes.onBoarding:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const OnBoarding(),
        );
      case Routes.home:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const Home(),
        );
      case Routes.dashboard:
        final arg = settings.arguments as Dashboard;
        return MaterialPageRoute<dynamic>(
          builder: (context) => Dashboard(hasLeading: arg.hasLeading),
        );
      case Routes.createWallet:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const CreateWalletScreen(),
        );
      case Routes.editWallet:
        final arg = settings.arguments as EditWalletScreen;
        return MaterialPageRoute<dynamic>(
          builder: (context) => EditWalletScreen(
            walletModel: arg.walletModel,
            totalWallet: arg.totalWallet,
          ),
        );
      case Routes.nameWallet:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const NameWallet(),
        );
      case Routes.balanceWallet:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const BalanceWallet(),
        );
      case Routes.typeWallet:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const TypeWallet(),
        );
      case Routes.transactionFull:
        final arg = settings.arguments as TransactionFull;
        return MaterialPageRoute<dynamic>(
          builder: (context) => TransactionFull(walletModel: arg.walletModel),
        );
      case Routes.handleTransaction:
        final arg = settings.arguments as HandleTransaction;
        return MaterialPageRoute<dynamic>(
          builder: (context) => HandleTransaction(
              transactionModel: arg.transactionModel,
              preCgExpense: arg.preCgExpense,
              preCgIncome: arg.preCgIncome,
              startDate: arg.startDate,
              endDate: arg.endDate,
              walletModel: arg.walletModel),
        );
      case Routes.selectWallet:
        final arg = settings.arguments as SelectWallet;
        return MaterialPageRoute<dynamic>(
          builder: (context) =>
              SelectWallet(createTransaction: arg.createTransaction),
        );
      case Routes.expenseCategories:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const ExpenseCategories(),
        );
      case Routes.incomeCategories:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const IncomeCategories(),
        );
      case Routes.noteTransaction:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const NoteTransaction(),
        );
      case Routes.premium:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const Premium(),
        );
      case Routes.currency:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const CurrencyCustom(),
        );
      case Routes.webViewPrivacy:
        final WebViewPrivacy arg = settings.arguments as WebViewPrivacy;
        return MaterialPageRoute<dynamic>(
          builder: (context) => WebViewPrivacy(
            url: arg.url,
            title: arg.title,
          ),
        );
      case Routes.premiumSuccess:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const PremiumSuccessful(),
        );
      case Routes.chartAnalysis:
        final arg = settings.arguments as ChartAnalysis;
        return MaterialPageRoute<dynamic>(
          builder: (context) => ChartAnalysis(
              curInxTypeDate: arg.curInxTypeDate,
              curInxMonth: arg.curInxMonth,
              curInxYear: arg.curInxYear,
              datetime: arg.datetime,
              walletModel: arg.walletModel,
              typeAnalysis: arg.typeAnalysis),
        );
      case Routes.transactionsDetail:
        final arg = settings.arguments as TransactionsDetail;
        return MaterialPageRoute<dynamic>(
          builder: (context) => TransactionsDetail(
            transactions: arg.transactions,
            title: arg.title,
            balance: arg.balance,
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
