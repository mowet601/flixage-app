import 'package:flixage/bloc/authentication/authentication_bloc.dart';
import 'package:flixage/bloc/notification/notification_bloc.dart';
import 'package:flixage/bloc/register/register_bloc.dart';
import 'package:flixage/bloc/register/register_event.dart';
import 'package:flixage/bloc/register/register_state.dart';
import 'package:flixage/generated/l10n.dart';
import 'package:flixage/repository/authentication_repository.dart';
import 'package:flixage/ui/widget/stateful_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  static const route = "register";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Dołącz już dziś do Flixage",
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          RegisterForm(),
        ],
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notificationBloc = Provider.of<NotificationBloc>(context);
    final authenticationRepository = Provider.of<AuthenticationRepository>(context);

    final bloc = RegisterBloc(Provider.of<AuthenticationBloc>(context),
        authenticationRepository, notificationBloc);

    return StatefulWrapper(
      onInit: () {
        _usernameController.addListener(() {
          bloc.dispatch(TextChangedEvent(
            username: _usernameController.text,
            password: _passwordController.text,
            repeatPassword: _repeatPasswordController.text,
          ));
        });

        _passwordController.addListener(() {
          bloc.dispatch(TextChangedEvent(
            username: _usernameController.text,
            password: _passwordController.text,
            repeatPassword: _repeatPasswordController.text,
          ));
        });

        _repeatPasswordController.addListener(() {
          bloc.dispatch(TextChangedEvent(
            username: _usernameController.text,
            password: _passwordController.text,
            repeatPassword: _repeatPasswordController.text,
          ));
        });
      },
      onDispose: () {
        _usernameController.dispose();
        _passwordController.dispose();
        _repeatPasswordController.dispose();

        bloc.dispose();
      },
      child: StreamBuilder<RegisterState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          final state = snapshot.data;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                readOnly: state is RegisterLoading,
                decoration: InputDecoration(
                  errorText: (state is RegisterValidatorError)
                      ? state.usernameValidator.error
                      : null,
                  hintText: S.current.authenticationPage_username,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: _passwordController,
                readOnly: state is RegisterLoading,
                obscureText: true,
                decoration: InputDecoration(
                  errorText: (state is RegisterValidatorError)
                      ? state.passwordValidator.error
                      : null,
                  border: InputBorder.none,
                  hintText: S.current.authenticationPage_password,
                  filled: true,
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: _repeatPasswordController,
                readOnly: state is RegisterLoading,
                obscureText: true,
                decoration: InputDecoration(
                  errorText: (state is RegisterValidatorError)
                      ? state.passwordValidator.error
                      : null,
                  border: InputBorder.none,
                  hintText: S.current.registerPage_repeatPassword,
                  filled: true,
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              RaisedButton(
                child: Text(S.current.authenticationPage_register.toUpperCase()),
                color: Theme.of(context).primaryColor,
                onPressed: state is RegisterLoading
                    ? null
                    : () => bloc.dispatch(
                          RegisterAttempEvent(
                            username: _usernameController.value.text,
                            password: _passwordController.value.text,
                            repeatPassword: _repeatPasswordController.value.text,
                          ),
                        ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: StadiumBorder(),
              ),
            ],
          );
        },
      ),
    );
  }
}