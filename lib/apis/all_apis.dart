// final isLive =
//     const String.fromEnvironment('PROD', defaultValue: 'false').toLowerCase() ==
//         'true';

// final String baseUrl = isLive == true
//     ? "https://v3.api.phyfarm.com/api"
//     : "https://dev.phyfarm.com/api";
// final String mqttHostUrl = isLive == true
//     ? "wss://stream.phyfarm.com"
//     : "wss://stream.dev.phyfarm.com";

final String baseUrl ="https://tourneyb-backend.vercel.app";



//deployment testing testing

class AppUrl {
  static String registerUserApi = "$baseUrl/api/v1/auth/register";
  static String loginUserApi = "$baseUrl/api/v1/auth/login";
  static String uniqueUsernameMobile = "$baseUrl/api/v1/auth/unique";
  static String newsFetchApi = "$baseUrl/api/v1/auth/login";
}
