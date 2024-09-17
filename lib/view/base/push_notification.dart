// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth; 
// import 'package:googleapis/servicecontrol/v1.dart';

// // class PushNotificationService {
// //   static Future<String> getAccessToken() async {
// //     final serviceAccountJson = {
// //       "type": "service_account",
// //       "project_id": "delivery-man-app-a80d8",
// //       "private_key_id": "61caa987007ee46212a8ef3d4398ed8b4e9643fa",
// //       "private_key":
// //           "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCInk6M0qzoaqJV\nm99NvVKGmVICX5bh0+o3fGaoOQLzHwQEJiC7fl+D9h8ipIeo7WQgGX9613vDTG5p\nu8cCTUTut4yQVGhGBO74daKfZKUcBg+I1Xl7lnEpIAoUDjE9EG0k3RaHDLyMV14I\nqvN/s1VKoQCfEy145GQ8s3Ls+60Pc1KmG6KBN3xQysR9DcXKmsV7ln9r50Ol08Hb\nZ85UcvYLHVoXXIPwaquJiVSP3J476K++V6B1WrFqRfnrQX5bl36kj6bD8Z/uO7yq\n9nQEVCGPv/4eUKZ2mbeZLqeua1uGQxhBYht0bhrt6cTz0LviarWdzQuq7B4QQaDs\nXrjoJKh1AgMBAAECggEAD4QDIcUvc/ngU96u/rI4tCanhLN8fEtH92M+eW54Ikps\nd1gpMYIJsP/7y0BqU8oaK/cZXkcovCZrB8EWufEymfXold+wM/uNdFRP0tBoXAVo\nMD8mW93bHjOQUXTHLMs3yg795vqQU1P8zvkzTFZ+okokuuw/ptIxfB9ZNwbiQbXJ\nuoYHmIPIbvrZAyWAPYJhYolrVVfiKxHqllOBjs04rV0ciE1GRsqcuxorI9l75UHh\nRHubOj2Ipi1cARfS6YWZfn5+rrTCGZejnUfx2LGQgDzWNMMf4zSOD6e1Lo76FJp+\nm+02SXoiOwJftWnjlbFJym6VEHR9m3a8EyG+ngM1YQKBgQC9o67QZcercaY9Rj/d\nDBxkvxzoMIa8Rljyb/zJ1p0ZXFeAKO1Cz234Pp1Ig7TXZkKZTtB6O8RIRCYDnDZT\nxBfc79bKn4FGoIGaE5qJXtalT5nujFDDlJRIlp4c4foBmbjDuqmaswIYqWkF5zPl\nOei5AjXGkQPNvPNqYBw6I61G+QKBgQC4bOKVjcB5LFlkpcdKxM0K0i9NdqG5Pzbt\nRBE3hdKT/IvvI4MmKT7kawzZ7wk1Y1zgqgmnJEVha4h7Q2PEW9cqa/pFy8nZwYI8\nj+BMKv8T+PlvgtHyawAPE20Na69XzlJucgVvxnalmm8/wvzD9j6FpWFs02ngaBF0\nFaxEgtjgXQKBgC5Y37Oc/GShPQDCt379o77XmmgA3B0NkFWIGx71LaXyFIyE9B+c\n9IJ0Qxpi3gK6wlIXmgoVq04CIcxGFFz6kt5zW2pf+0dYmPQgEGe8Xvc98iAD+QUj\nve3TqcbjT6eueyKS7zqYv01psfo4XE2Mjp0QtjXWYTiaEl+QJ7Xp3EJ5AoGBALX4\nsiXwxT6K1PWrYZZT0yFfPM9JQ8++IRtBs18+iwX8BbMDLk/EGMtXGUocQtDL5wPC\no12pO1Ahw3wkhVdla0vvWPXvW46iEjhhmmZtclypqK0vvqpci6VUfKDmZQ/Vg554\noQamI8HJPQYEBlXxLcW+5f90Jx8GcFpDXEQJe6b9AoGASODLSa0LbjTRZNmdr73b\na0GBNvLFTvTSqah8D3MHBnQ12OXpaQBL8cCnZPu38LqJr6kow0MLWhUHeEwZZ5O1\nqtSjn94adz0woEWPltfWB5eY7vBEjhZ9qLMc2qRtUW5h9U20b3nDteKg80gtcb1F\nKkZ8PkLom61KrzcA1Zofd0I=\n-----END PRIVATE KEY-----\n",
// //       "client_email":
// //           "delivery-man-app@delivery-man-app-a80d8.iam.gserviceaccount.com",
// //       "client_id": "108453208640286877075",
// //       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
// //       "token_uri": "https://oauth2.googleapis.com/token",
// //       "auth_provider_x509_cert_url":
// //           "https://www.googleapis.com/oauth2/v1/certs",
// //       "client_x509_cert_url":
// //           "https://www.googleapis.com/robot/v1/metadata/x509/delivery-man-app%40delivery-man-app-a80d8.iam.gserviceaccount.com",
// //       "universe_domain": "googleapis.com"
// //     };
// //     List<String> scopes = [
// //       "https://www.googleapis.com/auth/userinfo.email"
// //           "https://www.googleapis.com/auth/firebase.database"
// //           "https://www.googleapis.com/auth/firebase.messaging"
// //     ];
// //     http.Client client =await auth.clientViaServiceAccount(
// //       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
// //       scopes,
// //     );
// //     auth.AccessCredentials credentials =await auth.obtainAccessCredentialsViaServiceAccount(
// //       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
// //       scopes,
// //       client
// //     );
// //     client.close();
// //     return credentials.accessToken.data;
// //   }

// //   static sendNotificationToSelectDriver(
// //       String deviceToken, BuildContext context, String tripID) async{
// //             //  String dropoffDestinatioAddress =provider.of    

// //         final String serverKey= await getAccessToken();

// //         String endpointFirebaseCloudMessaging='https://fcm.googleapis.com/v1/projects/delivery-man-app-a80d8/messages:send';    
// //         final Map<String , dynamic>message=
// //         {
// //           'message':
// //           {
// //                'token': deviceToken,
// //                'Notification' : 
// //                {
// //                 'title': "",
// //                 'body' : ""
                  
// //                }
// //           }
// //         }  ; }
// // }


// sendNotificationToSelectDriver(
//    String deviceToken, BuildContext context, String tripID) async {
//  final String serverKey = await getAccessToken();
//  String endpointFirebaseCloudMessaging = 
//      'https://fcm.googleapis.com/v1/projects/delivery-man-app-a80d8/messages:send';
 
//  final Map<String, dynamic> message = {
//    'message': {
//      'token': deviceToken,
//      'notification': {
//        'title': "New Order Assigned",
//        'body': "You have been assigned a new order. Trip ID: $tripID",
//      }
//    }
//  };
 
//  await http.post(
//    Uri.parse(endpointFirebaseCloudMessaging),
//    headers: {
//      'Content-Type': 'application/json',
//      'Authorization': 'Bearer $serverKey',
//    },
//    body: jsonEncode(message),
//  );
//    }



//   Future<String> getAccessToken() async {
//   final response = await http.get(Uri.parse('https://your-backend.com/get-firebase-key'));
  
//   if (response.statusCode == 200) {
//     return response.body;
//   } else {
//     throw Exception('Failed to get Firebase Server Key');
//   }
// }


// Future<void> performPostRequest() async {
//   final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   final token = sharedPreferences.getString('token');
   
//   final response = await http.get(Uri.parse('${AppConstants.currentOrdersUri}${sharedPreferences.get(AppConstants.token)}'));
//   log("${sharedPreferences.get(AppConstants.token)}");

//   if (response.statusCode == 200) {
//     try {
//       final responseData = jsonDecode(response.body);

//       if (responseData is List) {
//         int? previousLength = sharedPreferences.getInt('response_data_length');
//         if (previousLength == null || previousLength != responseData.length) {
//           await sharedPreferences.setInt('response_data_length', responseData.length);
//         } else {
//           log('Length is the same: ${responseData.length}');
//         }
//       } else {
//         log('Response is not a list.');
//       }
//     } catch (e) {
//       log('Failed to decode response: $e');
//     }
//   } else {
//     log('Request failed: ${response.statusCode}');
//   }
// }

