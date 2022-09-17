import 'package:equatable/equatable.dart';
import 'package:monsey/common/model/type_wallet_model.dart';

class WalletModel extends Equatable {
  const WalletModel(
      {required this.name,
      this.id,
      this.typeWalletModel,
      required this.incomeBalance,
      required this.expenseBalance,
      required this.typeWalletId,
      required this.userUuid});
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      name: json['name'],
      userUuid: json['user_uuid'],
      typeWalletId: json['type_wallet_id'],
      incomeBalance: double.tryParse(json['income_balance'].toString()) ?? 0,
      expenseBalance: double.tryParse(json['expense_balance'].toString()) ?? 0,
      typeWalletModel: TypeWalletModel.fromJson(json['TypeWallet']),
    );
  }
  final int? id;
  final String userUuid;
  final String name;
  final int typeWalletId;
  final double incomeBalance;
  final double expenseBalance;
  final TypeWalletModel? typeWalletModel;

  @override
  List<Object?> get props => [
        id,
        userUuid,
        name,
        typeWalletId,
        incomeBalance,
        expenseBalance,
        typeWalletModel,
      ];
}
