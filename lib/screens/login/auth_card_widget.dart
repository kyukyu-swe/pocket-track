import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ));
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, -1.5), end: const Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    //_heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error occurred!'),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                    child: const Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
      }
    } catch (error) {
      var errorMessage = 'Authentication failed.';
      if (error.toString().contains('email-already-in-use')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('invalid-credential')) {
        errorMessage = 'Invalid email or password.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      }
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _formKey.currentState!.reset();
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _formKey.currentState!.reset();
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 280,
        //height: _heightAnimation.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 380 : 320),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 80 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(_authMode == AuthMode.Login
                              ? 'LOGIN'
                              : 'SIGN UP'),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          // padding:
                          //     EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                          // color: Theme.of(context).primaryColor,
                          // textColor: Theme.of(context).primaryTextTheme.button.color,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 40,
                  child: TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                    // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // textColor: Theme.of(context).primaryColor,
                  ),
                ),
                if (_authMode == AuthMode.Login)
                  SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(),
                            ));
                      },
                      child: Text('Forgot password'),
                      // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // textColor: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
