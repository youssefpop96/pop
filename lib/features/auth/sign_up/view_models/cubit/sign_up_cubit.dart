import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/core/repositories/auth_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;
  SignUpCubit(this._authRepository) : super(SignUpInitial());

  String? email;
  String? password;
  String? name;
  GlobalKey<FormState> signUpKey = GlobalKey();

  Future<void> signUp() async {
    if (signUpKey.currentState!.validate()) {
      emit(SignUpLoading());
      try {
        final response = await _authRepository.signUp(
          email: email!,
          password: password!,
          fullName: name,
        );

        if (response.session == null) {
          emit(
            SignUpSuccess(
              message:
                  'Account Created! Please check your email to confirm your account before logging in.',
            ),
          );
        } else {
          emit(SignUpSuccess(message: 'Account Created! Welcome.'));
        }
      } on AuthException catch (e) {
        emit(SignUpFailure(errMessage: e.message));
      } catch (e) {
        emit(
          SignUpFailure(
            errMessage: 'An unexpected error occurred: ${e.toString()}',
          ),
        );
      }
    }
  }

  Future<void> signUpWithGoogle() async {
    emit(SignUpLoading());
    try {
      await _authRepository.signInWithGoogle();
      emit(SignUpSuccess(message: 'Google Sign In successful. Welcome!'));
    } on AuthException catch (e) {
      emit(SignUpFailure(errMessage: e.message));
    } catch (e) {
      emit(SignUpFailure(errMessage: 'Google Sign In failed: ${e.toString()}'));
    }
  }
}
