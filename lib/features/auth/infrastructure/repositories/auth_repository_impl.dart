import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;
  final KeyValueStorageService keyValueStorageService;

  AuthRepositoryImpl({
    AuthDataSource? dataSource,
    KeyValueStorageService? keyValueStorageService,
  }) : dataSource = dataSource ?? AuthDatasourceImpl(),
       keyValueStorageService =
           keyValueStorageService ?? KeyValueStorageServiceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) async {
    final User user = await dataSource.login(email, password);

    await keyValueStorageService.setKeyValue('token', user.token);

    return user;
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return dataSource.register(email, password, fullName);
  }
}
