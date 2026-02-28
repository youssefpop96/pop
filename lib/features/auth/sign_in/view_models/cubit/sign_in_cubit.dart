import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  String? email;
  String? password;
  GlobalKey<FormState> signInKey = GlobalKey();

  Future<void> signIn() async {
    if (signInKey.currentState!.validate()) {
      emit(SignInLoading());
      try {
        final supabase = Supabase.instance.client;

        await supabase.auth.signInWithPassword(
          email: email,
          password: password!,
        );

        emit(SignInSuccess());
      } on AuthException catch (e) {
        emit(SignInFailure(errMessage: e.message));
      } catch (e) {
        emit(SignInFailure(errMessage: 'An unexpected error occurred'));
      }
    }
  }
}
