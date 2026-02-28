import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../../core/utilities/supabase_credentials.dart';

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

  Future<void> signUpWithGoogle() async {
    emit(SignUpLoading());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: SupabaseCredentials.googleWebClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(SignUpFailure(errMessage: 'Google Sign In cancelled'));
        return;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        emit(SignUpFailure(errMessage: 'Failed to retrieve tokens from Google.'));
        return;
      }

      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      emit(SignUpSuccess());
    } on AuthException catch (e) {
      emit(SignUpFailure(errMessage: e.message));
    } catch (e) {
      emit(SignUpFailure(errMessage: 'Google Sign In failed: ${e.toString()}'));
    }
  }
}
