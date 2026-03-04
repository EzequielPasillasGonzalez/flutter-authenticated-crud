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
  Future<User> checkAuthStatus(String token) async {
    final User user = await dataSource.checkAuthStatus(token);
    await keyValueStorageService.setKeyValue<String>('token', user.token);

    return user;
  }

  @override
  Future<User> login(String email, String password) async {
    final User user = await dataSource.login(email, password);

    await keyValueStorageService.setKeyValue<String>('token', user.token);

    return user;
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    final User user = await dataSource.register(email, password, fullName);
    await keyValueStorageService.setKeyValue<String>('token', user.token);
    return user;
  }
}
