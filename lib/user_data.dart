import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class UserData extends StatefulWidget {
  final String accessToken;

  const UserData({Key? key, required this.accessToken}) : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  String userId = '';
  String mediaCount = '';
  String userName = '';
  List<dynamic> mediaData = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchUserMedia();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse(
        'https://graph.instagram.com/me?fields=id,username,media_count&access_token=${widget.accessToken}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("Response: $data");
      if (data != null) {
        saveAccessToken(widget.accessToken);
        setState(() {
          userId = data['id'].toString();
          mediaCount = data['media_count'].toString();
          userName = data['username'].toString();
        });
      } else {
        print('Error: data field is null');
      }
    } else {
      // Handle other error cases
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    log('Saved sharedpreference');
  }

  Future<void> clearAllSavedStrings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
      (route) => false,
    );
  }

  Future<void> fetchUserMedia() async {
    final accessToken = widget.accessToken;
    const fields = 'id,media_type,media_url,username,timestamp';
    final url = Uri.parse(
        'https://graph.instagram.com/me/media?fields=$fields&access_token=$accessToken');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        mediaData = jsonData['data'];
      });
    } else {
      print('Failed to fetch media data. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        actions: [
          IconButton(
            onPressed: () {
              clearAllSavedStrings();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Username: $userName',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text(
                'User ID: $userId',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text(
                'Media Count: $mediaCount',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              const Text(
                'Media Data:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mediaData.length,
                itemBuilder: (context, index) {
                  final media = mediaData[index];
                  final mediaType = media['media_type'];
                  final mediaUrl = media['media_url'];
                  final username = media['username'];
                  final timestamp = media['timestamp'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Media Type: $mediaType'),
                      Text('Media URL: $mediaUrl'),
                      Text('Username: $username'),
                      Text('Timestamp: $timestamp'),
                      const Divider(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'dart:convert';
// import 'dart:developer';
// import 'package:facebook_insta_login_app/home.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class UserData extends StatefulWidget {
//   final String accessToken;

//   const UserData({super.key, required this.accessToken});

//   @override
//   State<UserData> createState() => _UserDataState();
// }

// class _UserDataState extends State<UserData> {
//   String userId = '';
//   String mediaCount = '';
//   String userName = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//     fetchUserMedia();
//   }

//   Future<void> fetchUserData() async {
//     final url = Uri.parse(
//         'https://graph.instagram.com/me?fields=id,username,media_count&access_token=${widget.accessToken}');
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       log("Response: $data");
//       if (data != null) {
//         saveAccessToken(widget.accessToken);
//         setState(() {
//           userId = data['id'].toString();
//           mediaCount = data['media_count'].toString();
//           userName = data['username'].toString();
//         });
//       } else {
//         print('Error: data field is null');
//       }
//     } else {
//       // Handle other error cases
//       print('Error: ${response.statusCode}');
//     }
//   }

//   Future<void> saveAccessToken(String token) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('accessToken', token);
//     log('Saved sharedprefecrnce');
//   }

//   Future<void> clearAllSavedStrings() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder: (context) => const Home(),
//         ),
//         (route) => false);
//   }

//   Future<void> fetchUserMedia() async {
//     final accessToken = widget.accessToken;
//     const fields = 'id,media_type,media_url,username,timestamp';
//     final url = Uri.parse(
//         'https://graph.instagram.com/me/media?fields=$fields&access_token=$accessToken');

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final mediaList = jsonData['data'];

//       // Parse and display media data
//       for (var media in mediaList) {
//         final mediaType = media['media_type'];
//         final mediaUrl = media['media_url'];
//         final username = media['username'];
//         final timestamp = media['timestamp'];

//         // Display media data in your Flutter app
//         log('Media Type: $mediaType');
//         log('Media URL: $mediaUrl');
//         log('Username: $username');
//         log('Timestamp: $timestamp');
//         log('---');
//       }
//     } else {
//       print('Failed to fetch media data. Error: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Data'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 clearAllSavedStrings();
//               },
//               icon: Icon(Icons.logout))
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Username: $userName',
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'User ID: $userId',
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Media Count: $mediaCount',
//               style: const TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
