// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:uni_links/uni_links.dart' as uni_link;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkDeepLink();
  runApp(MyApp());
}

Future checkDeepLink() async {
  StreamSubscription _sub;
  try {
    print("checkDeepLink");
    await uni_link.getInitialLink();
    _sub = uni_link.uriLinkStream.listen((Uri? uri) {
      print('uri: $uri');
      WidgetsFlutterBinding.ensureInitialized();
      runApp(MyApp(uri: uri));
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed

      print("onError");
    });
  } on PlatformException {
    print("PlatformException");
  } on Exception {
    print('Exception thrown');
  }
}

class MyApp extends StatelessWidget {
  final Uri? uri;
  //const MyApp({Key? key}) : super(key: key);
  MyApp({this.uri});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        uri: uri,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, this.uri}) : super(key: key);
  final Uri? uri;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await FlutterSocialContentShare.platformVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      //_platformVersion = platformVersion;
    });
  }

  /// SHARE ON FACEBOOK CALL
  shareOnFacebook() async {
    String? result = await FlutterSocialContentShare.share(
        type: ShareType.facebookWithoutImage,
        url: "https://flutterbooksample.com/page1",
        quote:
            "click to visit the app : https://flutterbooksample.com/page1  ");
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      // take action according to data uri
      if (widget.uri != null) {
        print('GET URI:');
        print(widget.uri.toString());

        List<String> splitted = widget.uri.toString().split('/');
        if (splitted[splitted.length - 1] == 'page1') {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage(widget.uri)));
        }
        if (splitted[splitted.length - 1] == 'page2') {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(widget.uri)));
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // ignore: avoid_unnecessary_ontainercontainers
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ignore: prefer_const_constructors
                Text(
                  'FELLOW4U',
                  style: const TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 30),

                // ignore: prefer_const_constructors
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.add_outlined,
                        size: 30,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Email'),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.add_outlined,
                        size: 30,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Password'),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: OutlinedButton(
                    child: const Text('Login with Email'),
                    onPressed: () {
                      print('Login!');
                      if (_formKey.currentState!.validate()) {
                        print('FORM IS OK!!!');
                        //
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: OutlinedButton(
                    child: const Text('Login with Facebook'),
                    onPressed: () async {
                      print('Login with Facebook!');

                      final LoginResult result =
                          await FacebookAuth.instance.login(
                        permissions: ['public_profile', 'email'],
                      );

                      if (result.status == LoginStatus.success) {
                        // you are logged
                        print('LOGIN TOKEN!!!!');
                        print(result.accessToken!.token);
                        final userData = await FacebookAuth.i.getUserData(
                          fields: "name,email",
                        );
                      } else {
                        print('YYYYY');
                        print(result.status);

                        print(result.message);
                      }
                    },
                  ),
                ),

                const SizedBox(height: 30),
                RaisedButton(
                  child: Text('Share to Facebook Link'),
                  onPressed: () async {
                    shareOnFacebook();
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.account_circle,
                        size: 50,
                      ),
                      onPressed: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: IconButton(
                        icon: const Icon(
                          Icons.account_circle_outlined,
                          size: 50,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.account_circle,
                        size: 50,
                      ),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
