import 'package:facebook_insta_login_app/user_data.dart';
import 'package:flutter/material.dart';
import 'package:insta_login/insta_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String token = '', userid = '', username = '', profilePicUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insta Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (token != '' || userid != '' || username != '')
                Text(
                  'Access Token: $token\n\nUser Id: $userid\n\nUsername: $username',
                )
              else
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SafeArea(
                              child: InstaView(
                                instaAppId: '1349157325774540',
                                instaAppSecret:
                                    '7fc591ee7a62bb520b41f565e8e0a164',
                                redirectUrl:
                                    'https://www.ledr.com/colours/white.htm',
                                //  'https://www.ekspar.com.tr/',
                                // 'https://ayesha-iftikhar.web.app/',
                                onComplete: (_token, _userid, _username) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (timeStamp) {
                                      setState(() {
                                        token = _token;
                                        userid = _userid;
                                        username = _username;
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserData(
                                            // username: username,
                                            accessToken: token,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Connect to Instagram'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
