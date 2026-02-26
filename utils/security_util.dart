import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

class SecurityUtil {
  /// Encrypt data using AES (ECB/PKCS7) and Hex key
  static String encryptAES(dynamic input, int time, String hexKey) {
    final payload = {'data': input, 'timestamp': time};

    final key = encrypt.Key(Uint8List.fromList(hexToBytes(hexKey)));
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'),
    );

    final encrypted = encrypter.encrypt(jsonEncode(payload));
    return encrypted.base64;
  }

  /// Encrypt using RSA public key PEM
  /// Convert Hex string to bytes
  static List<int> hexToBytes(String hex) {
    final result = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      final byte = hex.substring(i, i + 2);
      result.add(int.parse(byte, radix: 16));
    }
    return result;
  }

  static String encryptRSA(String payload, String publicKeyPem) {
    final key = parsePublicKeyFromPem(publicKeyPem);

    // Dùng OAEP với SHA-256 cho khớp với .NET
    final cipher = OAEPEncoding.withSHA256(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(key));

    final inputBytes = Uint8List.fromList(utf8.encode(payload));

    // Kiểm tra giới hạn
    final maxLen = (key.modulus!.bitLength ~/ 8) - 2 * 32 - 2;
    if (inputBytes.length > maxLen) {
      throw Exception(
        "Payload quá dài (${inputBytes.length} bytes), max: $maxLen bytes cho OAEP-SHA256 với key size ${key.modulus!.bitLength} bits",
      );
    }

    final output = cipher.process(inputBytes);
    return base64Encode(output);
  }

  /// Parse PEM Public Key (PKCS#8)
  static RSAPublicKey parsePublicKeyFromPem(String pem) {
    final b64 =
        pem
            .replaceAll('-----BEGIN PUBLIC KEY-----', '')
            .replaceAll('-----END PUBLIC KEY-----', '')
            .replaceAll('\n', '')
            .replaceAll('\r', '')
            .trim();

    final derBytes = base64Decode(b64);
    final asn1Parser = ASN1Parser(derBytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    final publicKeyBitString = topLevelSeq.elements[1] as ASN1BitString;

    final publicKeyAsn = ASN1Parser(publicKeyBitString.contentBytes());
    final publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;

    final modulus = (publicKeySeq.elements[0] as ASN1Integer).valueAsBigInteger;
    final exponent =
        (publicKeySeq.elements[1] as ASN1Integer).valueAsBigInteger;

    return RSAPublicKey(modulus, exponent);
  }

  String encryptForXCipher(String plaintext, String publicKeyPem) {
    final publicKey = parsePublicKeyFromPem(publicKeyPem);
    final encryptor = OAEPEncoding.withSHA256(RSAEngine());
    encryptor.init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    final plainBytes = Uint8List.fromList(utf8.encode(plaintext));
    final cipherBytes = encryptor.process(plainBytes);

    return base64Encode(cipherBytes);
  }
}
