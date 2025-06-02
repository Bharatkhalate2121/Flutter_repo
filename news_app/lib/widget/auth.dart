import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/api_calls/get_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {
  Auth({super.key});

  State<Auth> createState() => _Auth();
}

class _Auth extends State<Auth> {
  String? password, userName;
  late bool theme;
  bool auth = true; //true for login, false for logut

  Future<void> handleAuth() async {
    Map<String, String> body = {
      'userName': userName ?? '',
      'password': password ?? '',
    };
    Future<String?> Function(Map<String, String>) getAuth = auth
        ? GetAuth.login
        : GetAuth.register;
    String? token = await getAuth(body);
    if (token == null) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('authorization', token);
    Provider.of<ContextClass>(context, listen: false).isLogged = true;
    return;
  }

  @override
  void initState() {
    super.initState();
    theme = !Provider.of<ContextClass>(context, listen: false).theme;
  }

  @override
  Widget build(BuildContext context) {
    theme = !Provider.of<ContextClass>(context, listen: false).theme;
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.all(0),
              color: theme ? Colors.white10 : Colors.black12,
              child: TextField(
                // enabled: false,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: theme ? Colors.white : Colors.black,
                  hint: Text("user name"),
                  hintStyle: TextStyle(
                    color: theme ? Colors.white10 : Colors.black12,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: theme ? Colors.white : Colors.black),
                onChanged: (value) => {
                  setState(() {
                    userName = value;
                  }),
                  print('$userName'),
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.all(0),
              color: theme ? Colors.white10 : Colors.black12,
              child: TextField(
                // enabled: false,
                maxLines: 1,
                obscureText: true,
                obscuringCharacter: '•',
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: theme ? Colors.white : Colors.black,
                  hint: Text("password"),
                  hintStyle: TextStyle(
                    color: theme ? Colors.white : Colors.black,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: theme ? Colors.white : Colors.black),
                onChanged: (value) => {
                  setState(() {
                    password = value;
                  }),
                  print('$password'),
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {
                // handleAuth();
              },
              child: Text(auth ? 'Login' : 'Register'),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
                backgroundColor: WidgetStatePropertyAll(
                  const Color.fromARGB(255, 30, 183, 243),
                ),
                foregroundColor: WidgetStatePropertyAll(Colors.black),
                minimumSize: WidgetStatePropertyAll(Size(double.infinity, 50)),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: RichText(
              text: auth
                  ? TextSpan(
                      children: [
                        TextSpan(
                          text: 'Not a member ?',
                          style: TextStyle(
                            color: theme ? Colors.white : Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' Register.',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                auth = false;
                              });
                            },
                        ),
                      ],
                    )
                  : TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already a member ?',
                          style: TextStyle(
                            color: theme ? Colors.white : Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' login.',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                auth = true;
                              });
                            },
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
