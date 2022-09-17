mixin Subscription {
  static String listenWallets = '''
    subscription listenWallets(\$user_uuid: String = "") {
      Wallet(where: {user_uuid: {_eq: \$user_uuid}}) {
        id
        expense_balance
        income_balance
        name
        type_wallet_id
        user_uuid
        TypeWallet {
          id
          icon
          name
        }
      }
    }
''';
}
