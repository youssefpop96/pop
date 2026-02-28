import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  String? email;
  String? password;
  String? name;
  GlobalKey<FormState> signUpKey = GlobalKey();

  Future<void> signUp() async {
    if (signUpKey.currentState!.validate()) {
      emit(SignUpLoading());
      try {
        final supabase = Supabase.instance.client;

        await supabase.auth.signUp(
          email: email,
          password: password!,
          data: {'full_name': name},
        );

        emit(SignUpSuccess());
      } on AuthException catch (e) {
        emit(SignUpFailure(errMessage: e.message));
      } catch (e) {
        emit(SignUpFailure(errMessage: 'An unexpected error occurred'));
      }
    }
  }
}
