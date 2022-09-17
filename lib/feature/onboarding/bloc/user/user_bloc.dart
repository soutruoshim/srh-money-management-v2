import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:monsey/common/graphql/mutations.dart';
import 'package:monsey/common/model/user_model.dart';
import 'package:monsey/common/util/helper.dart';

import '../../../../common/graphql/config.dart';
import 'bloc_user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserLoading()) {
    on<GetUser>(_onGetUser);
    on<UpdateCurrencyUser>(_onUpdateCurrencyUser);
    on<UpdatePremiumUser>(_onUpdatePremiumUser);
  }
  User firebaseUser = FirebaseAuth.instance.currentUser!;

  UserModel? userModel;

  Future<void> _onGetUser(GetUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      userModel = event.userModel;
      if (userModel != null) {
        emit(UserLoaded(user: userModel!));
      }
    } catch (_) {
      emit(UserError());
    }
  }

  Future<void> _onUpdateCurrencyUser(
      UpdateCurrencyUser event, Emitter<UserState> emit) async {
    final state = this.state;
    if (state is UserLoaded) {
      emit(UserLoading());
      try {
        updateUserInfo(event.currencyCode, event.currencySymbol);
        userModel = UserModel(
            id: userModel!.id,
            name: userModel!.name,
            email: userModel!.email,
            uuid: userModel!.uuid,
            datePremium: userModel!.datePremium,
            avatar: userModel!.avatar,
            currencyCode: event.currencyCode,
            currencySymbol: event.currencySymbol);
        emit(UserLoaded(user: userModel!));
      } catch (_) {
        emit(UserError());
      }
    }
  }

  Future<void> _onUpdatePremiumUser(
      UpdatePremiumUser event, Emitter<UserState> emit) async {
    final state = this.state;
    if (state is UserLoaded) {
      emit(UserLoading());
      try {
        updatePremiumUser();
        userModel = UserModel(
            id: userModel!.id,
            name: userModel!.name,
            email: userModel!.email,
            uuid: userModel!.uuid,
            avatar: userModel!.avatar,
            datePremium: now,
            currencyCode: userModel!.currencyCode,
            currencySymbol: userModel!.currencySymbol);
        emit(UserLoaded(user: userModel!));
      } catch (_) {
        emit(UserError());
      }
    }
  }

  Future<void> updateUserInfo(
      String currencyCode, String currencySymbol) async {
    final String token = await firebaseUser.getIdToken();
    await Config.initializeClient(token).value.mutate(MutationOptions(
            document: gql(Mutations.updateCurencyUser()),
            variables: <String, dynamic>{
              'uuid': firebaseUser.uid,
              'currency_code': currencyCode,
              'currency_symbol': currencySymbol
            }));
  }

  Future<void> updatePremiumUser() async {
    final String token = await firebaseUser.getIdToken();
    await Config.initializeClient(token).value.mutate(MutationOptions(
            document: gql(Mutations.updatePremiumUser()),
            variables: <String, dynamic>{
              'uuid': firebaseUser.uid,
              'date_premium': now.toIso8601String(),
            }));
  }
}
