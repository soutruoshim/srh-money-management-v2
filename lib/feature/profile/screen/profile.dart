import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:monsey/common/constant/images.dart';
import 'package:monsey/common/constant/styles.dart';
import 'package:monsey/common/preference/shared_preference_builder.dart';
import 'package:monsey/common/route/routes.dart';
import 'package:monsey/common/widget/animation_click.dart';
import 'package:monsey/feature/onboarding/bloc/user/bloc_user.dart';

import '../../../app/widget_support.dart';
import '../../../common/constant/colors.dart';
import '../../../common/graphql/config.dart';
import '../../../common/graphql/mutations.dart';
import '../../../common/util/helper.dart';
import '../../../translations/export_lang.dart';
import '../../home/screen/dashboard.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  Future<void> deleteUser() async {
    final User firebaseUser = FirebaseAuth.instance.currentUser!;
    final String token = await firebaseUser.getIdToken();
    await Config.initializeClient(token).value.mutate(MutationOptions(
        document: gql(Mutations.deleteUser()),
        variables: <String, dynamic>{'uuid': firebaseUser.uid}));
  }

  Widget accountSetting(BuildContext context) {
    final List<Map<String, dynamic>> settings = [
      <String, dynamic>{
        'icon': icWallet,
        'name': LocaleKeys.wallet.tr(),
        'onTap': () {
          Navigator.of(context).pushNamed(Routes.dashboard,
              arguments: const Dashboard(hasLeading: true));
        }
      },
      <String, dynamic>{
        'icon': icCurrency,
        'name': LocaleKeys.currency.tr(),
        'onTap': () async {
          final currency = await Navigator.of(context)
              .pushNamed(Routes.currency) as Currency?;
          if (currency != null) {
            context
                .read<UserBloc>()
                .add(UpdateCurrencyUser(currency.code, currency.symbol));
          }
        }
      },
      <String, dynamic>{
        'icon': icLock,
        'name': LocaleKeys.logout.tr(),
        'onTap': () async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.onBoarding, (route) => false);
        }
      },
      <String, dynamic>{
        'name': LocaleKeys.deleteAccount.tr(),
        'onTap': () {
          AppWidget.showDialogCustom(LocaleKeys.deleteYourAccount.tr(),
              context: context, remove: () async {
            Navigator.of(context).pop();
            AppWidget.showLoading(context: context);
            await removeStorage();
            await deleteUser();
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.onBoarding, (route) => false);
            ScaffoldMessenger.of(context).showSnackBar(
              AppWidget.customSnackBar(
                content: LocaleKeys.deleteSuccess.tr(),
              ),
            );
          });
        }
      }
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Text(
            LocaleKeys.accountSettings.tr(),
            style: headline(color: grey2),
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox();
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: settings.length,
            itemBuilder: (context, index) {
              return AnimationClick(
                function: settings[index]['onTap'],
                child: ListTile(
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      settings[index]['icon'] == null
                          ? const SizedBox()
                          : Image.asset(
                              settings[index]['icon'],
                              width: 24,
                              height: 24,
                              color: purplePlum,
                            ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          settings[index]['name'],
                          style: body(context: context),
                        ),
                      ),
                      if (index == 1) ...[
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: grey5,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            BlocProvider.of<UserBloc>(context)
                                    .userModel!
                                    .currencyCode ??
                                'USD',
                            style: subhead(color: grey1),
                          ),
                        )
                      ],
                      const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        size: 24,
                        color: grey4,
                      )
                    ],
                  ),
                  subtitle: AppWidget.divider(context, vertical: 8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserLoaded) {
          final bool isPremium = checkPremium(state.user.datePremium);
          return Scaffold(
            backgroundColor: isPremium ? emerald : white,
            appBar: AppWidget.createSimpleAppBar(
                context: context,
                title: LocaleKeys.profile.tr(),
                hasLeading: false,
                colorTitle: isPremium ? white : emerald,
                backgroundColor: isPremium ? emerald : white,
                action: Image.asset(icPencilEdit,
                    width: 24, height: 24, color: purplePlum)),
            body: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isPremium
                          ? Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(state.user.avatar),
                                  radius: 60,
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 5,
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: blueCrayola,
                                            borderRadius:
                                                BorderRadius.circular(48)),
                                        child: Image.asset(icCrown,
                                            color: white,
                                            height: 24,
                                            width: 24)))
                              ],
                            )
                          : Expanded(
                              child: CircleAvatar(
                              backgroundImage: NetworkImage(state.user.avatar),
                              radius: 60,
                            )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          state.user.name,
                          style: isPremium
                              ? title3(color: white)
                              : title3(context: context),
                        ),
                      ),
                      Text(
                        state.user.email,
                        style: body(color: isPremium ? white : grey3),
                      ),
                      isPremium
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  const Expanded(child: SizedBox()),
                                  Expanded(
                                    flex: 2,
                                    child: AppWidget.typeButtonStartAction(
                                        context: context,
                                        input: LocaleKeys.getPremium.tr(),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed(Routes.premium);
                                        },
                                        bgColor: emerald,
                                        textColor: white,
                                        sizeAsset: 24,
                                        colorAsset: white,
                                        icon: icAward),
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(32))),
                    child: accountSetting(context),
                  ),
                )
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
