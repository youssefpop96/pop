import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../../core/utilities/supabase_credentials.dart';

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

  Future<void> signInWithGoogle() async {
    emit(SignInLoading());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: SupabaseCredentials.googleWebClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(SignInFailure(errMessage: 'Google Sign In cancelled'));
        return;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        emit(SignInFailure(errMessage: 'Failed to retrieve tokens from Google.'));
        return;
      }

      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      emit(SignInSuccess());
    } on AuthException catch (e) {
      emit(SignInFailure(errMessage: e.message));
    } catch (e) {
      emit(SignInFailure(errMessage: 'Google Sign In failed: ${e.toString()}'));
    }
  }
}
