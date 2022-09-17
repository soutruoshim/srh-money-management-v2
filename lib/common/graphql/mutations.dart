mixin Mutations {
  static String insertUser() {
    return '''mutation InsertUserOne(\$uuid: String = "", \$name: String = "", \$email: String = "", \$avatar: String = "", \$currency_code: String = "", \$currency_symbol: String = "") {
      insert_User_one(object: {uuid: \$uuid, name: \$name, email: \$email, avatar: \$avatar, currency_code: \$currency_code, currency_symbol: \$currency_symbol}) {
        id
        name
        email
        uuid
        currency_code
        currency_symbol
        avatar
        Currency {
          id
          name
          description
          code
        }
      }
    }
''';
  }

  static String updateCurencyUser() {
    return '''mutation UpdateUser(\$uuid: String = "", \$currency_code: String = "", \$currency_symbol: String = "") {
      update_User(where: {uuid: {_eq: \$uuid}}, _set: {currency_code: \$currency_code, currency_symbol: \$currency_symbol}) {
        returning {
          id
          email
          name
          uuid
          currency_code
          currency_symbol
          avatar
          date_premium
        }
      }
    }
''';
  }

  static String updatePremiumUser() {
    return '''mutation UpdateUser(\$uuid: String = "", \$date_premium: timestamp = "") {
      update_User(where: {uuid: {_eq: \$uuid}}, _set: {date_premium: \$date_premium}) {
        returning {
          id
          email
          name
          uuid
          currency_code
          currency_symbol
          avatar
          date_premium
        }
      }
    }
''';
  }

  static String deleteUser() {
    return '''mutation DeleteUser(\$uuid: String = "") {
      delete_User(where: {uuid: {_eq: \$uuid}}) {
        returning {
          id
        }
      }
    }
''';
  }

  static String createWallet() {
    return '''mutation InsertWallet(\$name: String = "", \$type_wallet_id: Int = 10, \$income_balance: float8 = "", \$expense_balance: float8 = "", \$user_uuid: String = "") {
      insert_Wallet_one(object: {name: \$name, type_wallet_id: \$type_wallet_id, income_balance: \$income_balance, expense_balance: \$expense_balance, user_uuid: \$user_uuid}) {
        id
        income_balance
        expense_balance
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

  static String updateWallet() {
    return '''mutation UpdateWallet(\$id: Int = 10, \$type_wallet_id: Int = 10, \$name: String = "") {
      update_Wallet(where: {id: {_eq: \$id}}, _set: {type_wallet_id: \$type_wallet_id, name: \$name}) {
        returning {
          id
          income_balance
          expense_balance
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
    }
''';
  }

  static String removeWallet() {
    return '''mutation DeleteWallet(\$id: Int = 10) {
      delete_Wallet(where: {id: {_eq: \$id}}) {
        returning {
          id
        }
      }
    }
''';
  }

  static String createTransaction() {
    return '''mutation InsertTransactionOne(\$wallet_id: Int = 10, \$category_id: Int = 10, \$balance: float8 = "", \$date: timestamp = "", \$note: String = "", \$type: TypeTransaction_enum = expense, \$photo_url: String = "") {
      insert_Transaction_one(object: {wallet_id: \$wallet_id, category_id: \$category_id, balance: \$balance, date: \$date, note: \$note, type: \$type, photo_url: \$photo_url}) {
        id
        wallet_id
        category_id
        balance
        type
        date
        note
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
  }

  static String updateTransaction() {
    return '''mutation UpdateTransaction(\$id: Int = 10, \$balance: float8 = "", \$category_id: Int = 10, \$date: timestamp = "", \$note: String = "", \$type: TypeTransaction_enum = expense, \$wallet_id: Int = 10, \$photo_url: String = "") {
      update_Transaction(where: {id: {_eq: \$id}}, _set: {balance: \$balance, category_id: \$category_id, date: \$date, note: \$note, type: \$type, wallet_id: \$wallet_id, photo_url: \$photo_url}) {
        returning {
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
            name
            type
            parrent_id
            icon
          }
        }
      }
    }
''';
  }

  static String removeTransaction() {
    return '''mutation DeleteTransaction(\$id: Int = 10) {
      delete_Transaction(where: {id: {_eq: \$id}}) {
        returning {
          id
        }
      }
    }
''';
  }
}
