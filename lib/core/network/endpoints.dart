class Endpoints {
  Endpoints._(); // private constructor (prevent instantiation)

  // ─── Auth ───
  static const String login = '/auth/login';
  static const String signup = '/auth/register';
  static const String logout = '/auth/logout';


  // ─── Accounts ───
  static const String accounts = '/accounts';
  static const String accountsMoneyStatements = '/accounts/money-statements';
  static const String accountsMetals = '/accounts/metals/';
  static const String accountsItemStatements = '/accounts/item-statements';
  static const String accountCreateAndEdit = '/accounts';
  static const String accountByType = '$accounts/bytypes';

  static String accountById(int id) => '$accounts/$id';
  static String accountMetals(int id) => '$accounts/metals/$id';

  // ─── Users ───
  static const String users = '/users';
  static String usersById(int id) => '$users/$id';
  static String usersDeactivate(int id) => '$users/$id/deactivate';
  static String usersActivate(int id) => '$users/$id/activate';


  // ─── Profile & Notifications ───
  static const String profile = '/profile';
  static const String notifications = '/notifications';
}