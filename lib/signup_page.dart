import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application/home_page.dart';
import 'package:flutter_application/model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool showPassword, isNewUser, forgotPassword;

  late String _userKey, _password;
  TextEditingController _userMobileNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late double screenWidth;
  late double screenHeight;

  bool isUsernameValidate = false;

  bool isPasswordValidate = false;

  late StateSetter submitStateChange;

  bool enabledButton = false;

  void initState() {
    initializeProperties();
    super.initState();
  }

  void initializeProperties() {
    showPassword = false;
    isNewUser = false;
    forgotPassword = false;
  }

  Future<void> signIn() async {
    try {
      bool canLogin = await getLogin(
          _userMobileNumberController.text, _passwordController.text);
      if (canLogin) {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(content: Text('Invalid User name and Password')));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!
          .showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }

  Future<bool> getLogin(String userKey, String password) async {
    final List<String>? userKeyValues =
        UserModel.sharedPreferences.getStringList(userKey);
    if (userKeyValues != null && userKeyValues.isNotEmpty) {
      if (userKey == userKeyValues[0] && password == userKeyValues[1]) {
        UserModel.currentUserKey = userKey;
        UserModel.userKeyValues = userKeyValues;
        UserModel.isUserLoggedIn = true;
      }
    }
    return UserModel.isUserLoggedIn;
  }

  Future<void> signUp() async {
    _userKey = _userMobileNumberController.text;
    _password = _passwordController.text;
    if (_password != _confirmPasswordController.text) {
      scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Password and confirm password does not match')));
      return;
    }
    UserModel.sharedPreferences
        .setStringList(_userKey, <String>[_userKey, _password]);
    setState(() {
      isNewUser = false;
    });

    scaffoldMessengerKey.currentState!
        .showSnackBar(SnackBar(content: Text('Successfully Registered')));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(28.0),
                  child: Image.asset('assets/images/image1.jpg'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _userMobileNumberController,
                  onChanged: (String value) {
                    if (!(value.length >= 3 && value.length <= 10)) {
                      submitStateChange(() {
                        enabledButton = false;
                      });
                    }
                  },
                  onSubmitted: (String value) {
                    if (value.length >= 3 && value.length <= 10) {
                      isUsernameValidate = true;
                    } else {
                      scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                          content:
                              Text('User name must have 3 to 10 characters')));
                    }
                    validateTextFields();
                  },
                  decoration: InputDecoration(
                    hintText: 'User Name',
                    suffixIcon: Icon(Icons.account_box),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                forgotPassword
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            'We will send your password to the mentioned Mobile number',
                            style: TextStyle(fontSize: 12)),
                      )
                    : TextField(
                        controller: _passwordController,
                        onChanged: (String value) {
                          if (!(value.length >= 3 && value.length <= 10)) {
                            submitStateChange(() {
                              enabledButton = false;
                            });
                          }
                        },
                        onSubmitted: (String value) {
                          if (value.length >= 3 && value.length <= 10) {
                            isPasswordValidate = true;
                          } else {
                            scaffoldMessengerKey.currentState!.showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Password must have 3 to 10 characters')));
                          }
                          validateTextFields();
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                Visibility(
                    visible: isNewUser,
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: Icon(Icons.lock),
                          labelText: 'Confirm Password'),
                    )),
                SizedBox(height: 20),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  submitStateChange = setState;
                  return Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        color: enabledButton ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: !enabledButton
                          ? null
                          : () {
                              if (isNewUser) {
                                signUp();
                              } else {
                                signIn();
                              }
                            },
                      child: Text(
                        isNewUser ? 'SIGNUP' : 'SUBMIT',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  );
                }),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isNewUser = !isNewUser;
                    });
                  },
                  child: Text(
                    isNewUser ? 'Already Have An Account?' : 'New User?',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void validateTextFields() {
    if (isUsernameValidate && isPasswordValidate) {
      submitStateChange(() {
        enabledButton = true;
      });
    } else if (!isUsernameValidate && !isPasswordValidate) {
      scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text('Please provide valid credentials')));
    }
  }
}
