import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth.dart';
import 'auth_card_widget.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({
    super.key,
  });

  @override
  _ForgotPasswordWidgetState createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  // final Map<String, String> _authData = {
  //   'email': '',
  //   'password': '',
  // };
  var _isLoading = false;
  final _emailController = TextEditingController();
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
      await Provider.of<Auth>(context, listen: false)
          .resetPassword(_emailController.text);
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('Succellful'),
          contentPadding: EdgeInsets.all(20),
          children: [
            Text('Password reset link is sent to your email'),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK')),
          ],
        ),
      );
    } catch (error) {
      print(error);
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8.0,
      child: Container(
        height: 220,
        //height: _heightAnimation.value.height,
        constraints: BoxConstraints(minHeight: 220),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {},
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
                          child: Text('Reset Password'),
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
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text('Login'),
                  // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
