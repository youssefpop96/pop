import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pop/core/services/database_service.dart';
import 'package:pop/core/repositories/notes_repository.dart';
import 'package:pop/core/repositories/auth_repository.dart';
import 'package:pop/core/utilities/supabase_credentials.dart';
import 'package:pop/features/auth/views/screens/auth_wrapper.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseCredentials.url,
    anonKey: SupabaseCredentials.anonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(
          create: (context) => NotesRepository(DatabaseService()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                NoteCubit(context.read<NotesRepository>())..fetchHomeData(),
          ),
        ],
        child: MaterialApp(
          title: 'Pulse Care',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}
