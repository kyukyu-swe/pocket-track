import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

import '../../constants/style.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  String _error = '';
  bool _isLoading = false;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Re-authenticate the user with their current password
        AuthCredential credential = EmailAuthProvider.credential(
          email: _auth.currentUser!.email!,
          password: _currentPassword,
        );
        setState(() {
          _isLoading = true;
        });
        await _auth.currentUser!.reauthenticateWithCredential(credential);

        // Update the password
        await _auth.currentUser!.updatePassword(_newPassword);
        setState(() {
          _isLoading = false;
        });

        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Successful!', style: primaryTextStyle(size: 14)),
            content: Text('Your password has changed',
                style: primaryTextStyle(size: 14)),
            actions: <Widget>[
              TextButton(
                child: Text('Ok', style: primaryTextStyle(size: 14)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        // Password successfully changed
        // You can navigate to another page or show a success message here
      } catch (e) {
        setState(() {
          _error = 'The current password is incorrect!';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: secondaryTextStyle(size: 16),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Current Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _currentPassword = value;
                  });
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _newPassword = value;
                  });
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm the new password';
                  }
                  if (value != _newPassword) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
              ),
              SizedBox(height: 12.0),
              Text(
                _error,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: _changePassword,
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
