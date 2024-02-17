import 'package:login/api/api_provider.dart';

class ApiRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    return _apiProvider.loginWithEmailAndPassword(email, password);
  }
}
