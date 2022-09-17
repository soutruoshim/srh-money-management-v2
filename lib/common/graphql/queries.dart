mixin Queries {
  static String getUser = '''
    query GetUser(\$uuid: String = "") {
      User(where: {uuid: {_eq: \$uuid}}) {
        id
        name
        email
        uuid
        currency_code
        currency_symbol
        avatar
        date_premium
      }
    }
  ''';
  static String getWallets = '''
    query GetWallets(\$user_uuid: String = "") {
      Wallet(where: {user_uuid: {_eq: \$user_uuid}}) {
        id
        user_uuid
        name
        type_wallet_id
        income_balance
        expense_balance
        TypeWallet {
          id
          name
          icon
        }
      }
    }
  ''';
  static String getTransactionsByWalletId = '''
    query GetTransactions(\$walletId: Int = 1) {
      Transaction(where: {wallet_id: {_eq: \$walletId}}, order_by: {date: desc}) {
        id
        wallet_id
        category_id
        balance
        date
        note
        type
        photo_url
        Category {
          id
          parrent_id
          name
          icon
          type
        }
      }
  }
''';

  static String getAllTransactions = '''
   query GetTransactions(\$user_uuid: String = "", \$_gte: timestamp = "", \$_lte: timestamp = "") {
      Transaction(where: {Wallet: {user_uuid: {_eq: \$user_uuid}}, date: {_gte: \$_gte, _lte: \$_lte}}, order_by: {date: desc}) {
        id
        wallet_id
        category_id
        balance
        date
        note
        type
        photo_url
        Category {
          id
          parrent_id
          name
          icon
          type
        }
      }
    }

''';

  static String getCategories = '''
    query GetCategories {
      Category {
        id
        parrent_id
        name
        icon
        type
      }
    }
  ''';
  static String getTypeWallet = '''
    query GetTypeWallet {
      TypeWallet {
        id
        name
        icon
      } 
    }
''';
}
