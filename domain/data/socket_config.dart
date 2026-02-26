class SocketConfig {
  final String? baseUrl;
  final String? path;
  final String? cipherRawJson;
  final String? signatureInput;
  final String? privateKeyPem;

  SocketConfig({
    required this.baseUrl,
    required this.path,
    required this.cipherRawJson,
    required this.signatureInput,
    required this.privateKeyPem,
  });
}
