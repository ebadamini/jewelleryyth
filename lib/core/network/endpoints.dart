class Endpoints {
  static const String login = '/auth/login';
  static const String signup = '/auth/register';
  static const String logout = '/auth/logout';

  static const String orders = '/orders';
  static const String customers = '/customers';

  static const String accounts = '/accounts';
  static const String accountsMoneyStatements = '/accounts/money-statements';
  static const String accountsMetals = '/accounts/metals';
  static const String accountsItemStatements = '/accounts/item-statements';

  static String accountById(int id) => '$accounts/$id';

  static String accountMetals(int id) => '$accounts/metals/$id';

  static const String users = '/users';
  static  String usersDeactivate(int id) => '$users/$id/deactivate';
  static  String usersActivate(int id) => '$users/$id/activate';
  static  String usersById(int id) => '$users/$id';





  static const String profile = '/profile';
  static const String notifications = '/notifications';
}
