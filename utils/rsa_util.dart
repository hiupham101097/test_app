import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:asn1lib/asn1lib.dart';

/// Utility class for RSA signing operations.
class CoreRsaUtil {
  /// Normalizes a PEM string: trims, removes extra lines, and ensures valid block structure.
  static String normalizePem(String pem) {
    final lines = pem.trim().split(RegExp(r'\r?\n'));
    final header = lines.firstWhere(
      (l) => l.contains('BEGIN RSA PRIVATE KEY'),
      orElse: () => '',
    );
    final footer = lines.firstWhere(
      (l) => l.contains('END RSA PRIVATE KEY'),
      orElse: () => '',
    );
    final body =
        lines
            .where((l) => !l.startsWith('-----'))
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty)
            .toList();
    return [header, ...body, footer].join('\n');
  }

  /// Parses a PKCS#1 PEM-encoded private key into an [RSAPrivateKey].
  /// Returns null if parsing fails.
  static RSAPrivateKey? parseRsaPrivateKeyFromPem(String pem) {
    try {
      final base64Str =
          pem.split('\n').where((line) => !line.startsWith('-----')).join();
      final derBytes = base64Decode(base64Str);
      final parser = ASN1Parser(derBytes);
      final sequence = parser.nextObject() as ASN1Sequence;

      final modulus = (sequence.elements[1] as ASN1Integer).valueAsBigInteger;
      final privateExponent =
          (sequence.elements[3] as ASN1Integer).valueAsBigInteger;
      final p = (sequence.elements[4] as ASN1Integer).valueAsBigInteger;
      final q = (sequence.elements[5] as ASN1Integer).valueAsBigInteger;

      return RSAPrivateKey(modulus, privateExponent, p, q);
    } catch (_) {
      // Parsing failed, return null
      return null;
    }
  }

  /// Signs the [input] string using the provided PEM-encoded private key.
  /// Returns the signature as a Base64-encoded string, or null if signing fails.
  static Future<String?> sign(String input, String privatePemContent) async {
    if (input.isEmpty || privatePemContent.isEmpty) {
      // Input or private key is empty, cannot sign
      return null;
    }

    final trimmedKey = privatePemContent.trim();
    if (!trimmedKey.contains('-----BEGIN RSA PRIVATE KEY-----') ||
        !trimmedKey.contains('-----END RSA PRIVATE KEY-----')) {
      // PEM headers are missing
      return null;
    }

    try {
      final normalizedPem = normalizePem(trimmedKey);
      final key = parseRsaPrivateKeyFromPem(normalizedPem);
      if (key == null) return null;

      final signer = Signer('SHA-256/RSA');
      signer.init(true, PrivateKeyParameter<RSAPrivateKey>(key));

      final inputBytes = Uint8List.fromList(utf8.encode(input));
      final sig = signer.generateSignature(inputBytes) as RSASignature;

      return base64Encode(sig.bytes);
    } catch (_) {
      // Signing failed
      return null;
    }
  }
}
