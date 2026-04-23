import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/error/exceptions.dart';

/// AES-256-GCM encryption for data stored in the local SQLite database.
/// The AES key is generated once per install and stored in the OS secure
/// enclave (Keychain / Keystore) via [FlutterSecureStorage].
abstract interface class EncryptionService {
  Future<String> encrypt(String plaintext);
  Future<String> decrypt(String ciphertext);
  Future<Uint8List> encryptBytes(Uint8List bytes);
  Future<Uint8List> decryptBytes(Uint8List encryptedBytes);
}

@LazySingleton(as: EncryptionService)
class EncryptionServiceImpl implements EncryptionService {
  EncryptionServiceImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _keyName = 'aes_256_key';

  Key? _cachedKey;

  Future<Key> _getOrCreateKey() async {
    if (_cachedKey != null) return _cachedKey!;
    final stored = await _secureStorage.read(key: _keyName);
    if (stored != null) {
      _cachedKey = Key(base64Decode(stored));
      return _cachedKey!;
    }
    final key = Key.fromSecureRandom(32); // 256-bit key
    await _secureStorage.write(
      key: _keyName,
      value: base64Encode(key.bytes),
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
    _cachedKey = key;
    return key;
  }

  @override
  Future<String> encrypt(String plaintext) async {
    try {
      final encrypted = await encryptBytes(
        Uint8List.fromList(utf8.encode(plaintext)),
      );
      return base64Encode(encrypted);
    } on Exception catch (_) {
      throw const EncryptionException();
    }
  }

  @override
  Future<String> decrypt(String ciphertext) async {
    try {
      final decrypted = await decryptBytes(base64Decode(ciphertext));
      return utf8.decode(decrypted);
    } on Exception catch (_) {
      throw const EncryptionException();
    }
  }

  @override
  Future<Uint8List> encryptBytes(Uint8List bytes) async {
    try {
      final key = await _getOrCreateKey();
      final iv = IV.fromSecureRandom(16);
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      final encrypted = encrypter.encryptBytes(bytes, iv: iv);
      // Prepend IV to ciphertext: [16 bytes IV][ciphertext]
      return Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);
    } on Exception catch (_) {
      throw const EncryptionException();
    }
  }

  @override
  Future<Uint8List> decryptBytes(Uint8List encryptedBytes) async {
    try {
      if (encryptedBytes.length < 16) throw const EncryptionException();
      final key = await _getOrCreateKey();
      final iv = IV(encryptedBytes.sublist(0, 16));
      final cipherBytes = encryptedBytes.sublist(16);
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      return Uint8List.fromList(
        encrypter.decryptBytes(Encrypted(cipherBytes), iv: iv),
      );
    } on Exception catch (_) {
      throw const EncryptionException();
    }
  }
}
