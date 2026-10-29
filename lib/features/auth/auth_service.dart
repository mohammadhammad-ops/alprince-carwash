import '../../models/user_model.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();

  AuthService._internal();

  factory AuthService() => instance;

  UserModel? currentUser;
  UserModel? _registeredUser;
  String? _password;

  bool get isLoggedIn => currentUser != null;

  Future<bool> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    if (_registeredUser != null) {
      return false;
    }

    final user = UserModel(name: name, phone: phone);

    _registeredUser = user;
    _password = password;
    currentUser = user;

    return true;
  }

  Future<bool> login({required String phone, required String password}) async {
    if (_registeredUser == null) {
      return false;
    }

    if (_registeredUser!.phone == phone && _password == password) {
      currentUser = _registeredUser;
      return true;
    }

    return false;
  }

  void updateProfile({required String name, required String phone}) {
    if (!isLoggedIn) return;

    final updatedUser = currentUser!.copyWith(name: name, phone: phone);

    currentUser = updatedUser;
    _registeredUser = updatedUser;
  }

  void logout() {
    currentUser = null;
  }
}
