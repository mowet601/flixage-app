import 'package:dio/dio.dart';
import 'package:flixage/bloc/authentication/authentication_bloc.dart';
import 'package:flixage/bloc/dio_util.dart';
import 'package:flixage/bloc/form_bloc.dart';
import 'package:flixage/generated/l10n.dart';
import 'package:flixage/repository/authentication_repository.dart';
import 'package:flixage/util/validation/common_validators.dart';
import 'package:flixage/util/validation/validator.dart';
import 'package:logger/logger.dart';

class LoginBloc extends FormBloc {
  // One upper, one lower, one number, no whitespace

  static final log = Logger();

  final AuthenticationBloc _authenticationBloc;
  final AuthenticationRepository _authenticationRepository;

  LoginBloc(this._authenticationBloc, this._authenticationRepository);

  @override
  Future<FormBlocState> onValid(SubmitForm event) async {
    try {
      final authentication = await _authenticationRepository.authenticate({
        'username': event.fields['username'],
        'password': event.fields['password'],
      });

      _authenticationBloc.dispatch(LoggedIn(authentication));

      return FormSubmitSuccess();
    } catch (e) {
      if (e is DioError) {
        if (e.type == DioErrorType.RESPONSE) {
          switch (e.response?.statusCode) {
            case 401:
              return Future.error(S.current.loginPage_invalidCredentials);
            case 400:
              // This exception should newer occur, unless validators are invalid
              log.e(
                  "Login validator is not properly implemented, server should not throw 400",
                  e);
              return Future.error(S.current.common_unknownError);
            case 503:
              return Future.error(S.current.loginPage_authenticationServiceUnvaiable);
            default:
          }
        }
      }

      return Future.error(
          mapCommonErrors(e, defaultValue: S.current.common_unknownError));
    }
  }

  @override
  Map<String, Validator> get validators => {
        'username': usernameValidator,
        'password': passwordValidator,
      };
}
