import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  final _secureStorage = FlutterSecureStorage();

  @override
  Future<T?> getValue<T>(String key) async {
    final value = await _secureStorage.read(key: key);

    if (value == null) return null;

    switch (T) {
      case const (int):
        return int.parse(value) as T;
      case const (String):
        return value as T;
      default:
        throw CustomError(
          message: 'Tipo de dato no soportado: ${T.runtimeType}',
          errorCode: 2,
        );
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    try {
      await _secureStorage.delete(key: key);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    switch (T) {
      case const (int):
        await _secureStorage.write(key: key, value: value.toString());
        break;
      case const (String):
        await _secureStorage.write(key: key, value: value as String);
        break;
      default:
        throw CustomError(
          message: 'Tipo de dato no soportado: ${T.runtimeType}',
          errorCode: 2,
        );
    }
  }
}
