import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/core/repositories/auth_repository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;
  SignInCubit(this._authRepository) : super(SignInInitial());

  String? email;
  String? password;
  GlobalKey<FormState> signInKey = GlobalKey();

  Future<void> signIn() async {
    if (signInKey.currentState!.validate()) {
      emit(SignInLoading());
      try {
        await _authRepository.signIn(email: email!, password: password!);
        emit(SignInSuccess());
      } on AuthException catch (e) {
        emit(SignInFailure(errMessage: e.message));
      } catch (e) {
        emit(
          SignInFailure(
            errMessage: 'An unexpected error occurred: ${e.toString()}',
          ),
        );
      }
    }
  }

  Future<void> signInWithGoogle() async {
    emit(SignInLoading());
    try {
      await _authRepository.signInWithGoogle();
      emit(SignInSuccess());
    } on AuthException catch (e) {
      emit(SignInFailure(errMessage: e.message));
    } catch (e) {
      emit(SignInFailure(errMessage: 'Google Sign In failed: ${e.toString()}'));
    }
  }
}
