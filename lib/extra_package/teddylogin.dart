library rameez_animated_login_screen;

import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rameez_animated_login_screen/login_data.dart';
import 'package:rameez_animated_login_screen/teddy_controller.dart';
import 'package:rameez_animated_login_screen/custom_text_input.dart';

// ignore: must_be_immutable
class RameezAnimatedLoginScreen extends StatefulWidget {
  RameezAnimatedLoginScreen(
      {Key? key,
      this.flareController,
      required this.routeAfterSuccessFulSignIn,
      this.passwordFieldCaretMovement,
      this.userFieldCaretMovement,
      required this.defaultAnimation,
      required this.validateUserNameAndPassword,
      this.flareImage,
      required this.usernameLabel,
      required this.passwordLabel,
      required this.themeBasedtextColor})
      : super(key: key);
  FlareControls? flareController;
  final CaretMoved? userFieldCaretMovement;
  final CaretMoved? passwordFieldCaretMovement;
  String? flareImage;
  final Future<bool> Function(LoginData loginData) validateUserNameAndPassword;
  final Function? routeAfterSuccessFulSignIn;
  final bool defaultAnimation;
  final String usernameLabel;
  final String passwordLabel;
  final Color themeBasedtextColor;

  @override
  __RameezAnimatedLoginScreenState createState() =>
      __RameezAnimatedLoginScreenState();
}

class __RameezAnimatedLoginScreenState
    extends State<RameezAnimatedLoginScreen> {
  bool _isLoading = false;
  bool _isObscured = true;
  String? username;
  String? password;
  late TeddyController teddyController2;
  @override
  void initState() {
    widget.flareController ??= TeddyController();
    if (widget.defaultAnimation && widget.flareImage == null) {
      //widget.flareImage ??= "assets/default.flr";
    }
    teddyController2 = TeddyController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: height * 0.01),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.flareImage == null
                ? SizedBox(
                    height: height * 0.25,
                  )
                : SizedBox(
                    height: height * 0.25,
                    child: FlareActor(
                      widget.flareImage,
                      shouldClip: false,
                      //alignment: Alignment.bottomCenter,
                      fit: BoxFit.contain,
                      controller: widget.flareController,
                    ),
                  ),
            Container(
              width: 400,
              height: height * 0.37,
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CustomTextInput(
                      key: const Key("username"),
                      onTextChanged: (String email) {
                        username = email;
                      },
                      label: widget.usernameLabel,
                      onCaretMoved: (Offset caret) {
                        if (widget.flareController is TeddyController) {
                          TeddyController? teddyController =
                              widget.flareController as TeddyController?;
                          teddyController!.coverEyes(false);
                          teddyController.lookAt(caret);
                        }
                        widget.userFieldCaretMovement!(caret);
                      },
                      icon: Icons.email,
                      enable: !_isLoading,
                      focusChange: (bool value) {},
                      themeBasedtextColor: widget.themeBasedtextColor,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: CustomTextInput(
                            key: const Key("password"),
                            onTextChanged: (String password) {
                              this.password = password;
                            },
                            label: widget.passwordLabel,
                            isObscured: _isObscured,
                            themeBasedtextColor: widget.themeBasedtextColor,
                            onCaretMoved: (Offset caret) {
                              if (widget.flareController is TeddyController) {
                              } else {
                                widget.passwordFieldCaretMovement!(caret);
                              }
                            },
                            icon: Icons.lock,
                            enable: !_isLoading,
                            focusChange: (bool value) {
                              widget.flareController ??= TeddyController();
                              if (widget.flareController != null) {
                                if (value) {
                                  widget.flareController!.play("hands_up");
                                } else {
                                  widget.flareController!.play("hands_down");
                                }
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: widget.themeBasedtextColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepOrange)),
                      child: _isLoading
                          ? const SpinKitThreeBounce(
                              color: Colors.white,
                              size: 25.0,
                            )
                          : const Text(
                              '登入',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                      onPressed: () {
                        TeddyController? teddyController;
                        setState(() {
                          _isLoading = true;
                        });
                        if (widget.flareController is TeddyController) {
                          teddyController =
                              widget.flareController as TeddyController?;
                        }

                        widget
                            .validateUserNameAndPassword(
                                LoginData(name: username!, password: password!))
                            .then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                          if (value) {
                            if (widget.flareController == null) {
                              widget.flareController = TeddyController();
                              widget.flareController!.play("success");
                            }
                            Timer _timer;
                            _timer =
                                Timer(const Duration(milliseconds: 500), () {
                              widget.routeAfterSuccessFulSignIn!();
                            });
                          } else {
                            teddyController!.play("fail");
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
