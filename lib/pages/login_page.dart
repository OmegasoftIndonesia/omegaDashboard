import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:upgrader/upgrader.dart';
import '../pages/dashboard_page.dart';
import '../constants/constants.dart';
import '../services/login_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginService loginService = LoginService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      canDismissDialog: true,
      dialogStyle: Platform.isAndroid
          ? UpgradeDialogStyle.material
          : UpgradeDialogStyle.cupertino,
      upgrader: Upgrader(
        minAppVersion: '1.0.1',
        messages: UpgraderMessages(code: 'id'),
      ),
      child: Scaffold(
        body: Container(
          color: const Color(Constants.colorMainApp),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "${Constants.imageAsset}logo.png",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  readOnly: false,
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, bottom: 10, top: 10),
                  ctrl: emailController,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "E-mail",
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'E-mail cannot be empty';
                    } else if (!input.isValidEmail()) {
                      return 'E-mail is not valid';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomTextFormField(
                  readOnly: false,
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, bottom: 10, top: 10),
                  ctrl: passwordController,
                  obscureText: true,
                  hintText: "Password",
                  keyboardType: TextInputType.text,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomButton(
                  backgroundColor: const Color(Constants.colorSecondaryApp),
                  foregroundColor: const Color(Constants.colorSecondaryApp),
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = !isLoading;
                            });
                            await loginService
                                .doLogin(
                                    emailController.text, passwordController.text)
                                .then((response) {
                              setState(() {
                                isLoading = !isLoading;
                              });
                              if (response[0].result == "100") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DashboardPage(),
                                  ),
                                );
                              } else {
                                EasyLoading.showError(
                                    "Username or password is not correct");
                              }
                            }).catchError((Object e) async {
                              setState(() {
                                isLoading = !isLoading;
                              });
                              EasyLoading.showError(
                                  "Something went wrong when login, try again later.");
                            });
                          }
                        },
                  textButton: "Login",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
