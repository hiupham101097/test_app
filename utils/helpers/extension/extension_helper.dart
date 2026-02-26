
extension ExtensionHelper on String {
  String lastChars(int n) => substring(length - n);
  String firstChars(int n) => substring(0, n);
  String? removeLastChars(int n) => substring(0, length - n);
}