class AppConstants {
  static const String appName = 'Test App';

  // API Constants
  static const int apiTimeout = 3000; // 30 seconds

  // Storage Keys
  static const String tokenKey = 'token';
  static const String userKey = 'user';
  static const String BOX_USER = 'BOX_USER';
  static const String BOX_STORE = 'BOX_STORE';
  static const String BOX_WALLET = 'BOX_WALLET';
  static const String BOX_WALLET_USER = 'BOX_WALLET_USER';
  static const double BASE_WIDTH = 430.0;
  static const double MAX_WIDTH = 430.0;
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6MSwiZW1haWxBZGRyZXNzIjoiaG9ob2FuZ3BodWNqb2JAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiSOG7kyIsImxhc3ROYW1lIjoiSG_DoG5nIFBow7pjIiwiZnVsbE5hbWUiOiJ1bmRlZmluZWQgdW5kZWZpbmVkIiwiYWRkcmVzcyI6IsSR4buLYSBjaOG7iSAxIiwicGhvbmVOdW1iZXIiOiIwMzI3NDM0ODIxIiwicHJpdmF0ZUtleSI6IjIzNTU3MWVlLWE0NzctNDFlMS1iMzIwLTY0NTE2NWRhMDBiYSIsImlzRW1sb3kiOnRydWUsImlhdCI6MTc1Njk2NTg2MiwiZXhwIjoxNzU3MDUyMjYyfQ.zkkacwnmecDiJO1KzV_7YrkbpKMSDEoz63aWp68MnJM';
  static const String clientID = 'chothongminh-me6njfan-FJN8X8';
  static const String clientIDDev = 'chothongminh-md1oncmj-B3G0WR';
  static const String securityKey =
      'c76422e2b216bfd1a4b598af46734f7785e7d53034a969fe1153958d465edbe1';
  static const String securityKeyDev =
      '4aa25ceea23aa1022fa976828f122fa7588162a82005b37a54bb0605cd71a4f0';

  // Deep Link Constants
  static const String appLink = 'zalopay';
  static const String approve = 'APPROVED';
  static const String reject = 'REJECTED';
  static const String refundPending = 'REFUND_PENDING';
  static const String pending = 'PENDING';
  static const String result = 'result';
  static const String open = 'OPEN';
  static const String close = 'CLOSE';
  static const String domainImage = 'https://s3-api.chothongminh.com';

  static const String refundFailed = 'REFUND_FAILED';
  static const String refundSuccess = 'REFUND_SUCCESS';
}
