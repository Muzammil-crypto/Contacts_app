import 'package:contact_app/Model/user.dart';
import 'package:contact_app/scop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPage();
  }
}

class _AuthPage extends State<AuthPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 10),
                _emialInputWidget(),
                SizedBox(height: 10),
                _passwordInputWidget(),
                SizedBox(height: 10),
                _logInWidget(),
                SizedBox(height: 10),
                _signUpWidget(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emialInputWidget() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }
      },
    );
  }

  Widget _passwordInputWidget() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.visiblePassword,

      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }
      },
    );
  }

  Widget _signUpWidget() {
    return ScopedModelDescendant<MyScopedModel>(
      builder: (BuildContext context, Widget child, MyScopedModel model) {
        return RaisedButton(
          child: Text("Sign Up"),
          onPressed: () {
            register(model);
          },
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
        );
      },
    );
  }

  Widget _logInWidget() {
    return ElevatedButton(
      child: Text("Sign in"),
      onPressed: () {},
      // color: Theme.of(context).primaryColor,
      // textColor: Colors.white,
    );
  }

  void register(MyScopedModel model) {
    if (_key.currentState.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      UserModel user = UserModel();
      user.email = email;
      user.password = password;
      model.registerUser(user).then((Map<String, dynamic> response) {
        if (response['success']) {
          //redirect to home screen
        } else {
          showDialog(
              builder: (context) => AlertDialog(
                    title: Text("Error in signing Up"),
                    content: Text(response['message']),
                  ),
              context: context);
        }
      });
    }
  }
}
