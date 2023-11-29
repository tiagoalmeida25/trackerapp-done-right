import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackerapp/bloc/app/app_bloc.dart';
import 'package:trackerapp/bloc_observer.dart';
import 'package:trackerapp/repositories/auth_repository.dart';
import 'package:trackerapp/router/app_router.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = const AppBlocObserver();
  final authRepository = AuthRepository();
  runApp(App(authRepository: authRepository));
}

class App extends StatelessWidget {
  // final AppRouter appRouter;
  final AuthRepository _authRepository;
  const App({Key? key, required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _authRepository,
        child: BlocProvider(
          create: (_) => AppBloc(authRepository: _authRepository),
          child: const AppView(),
        ));
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlowBuilder(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
