import 'package:bloc_chatapp/ui/SplashScreen/splash_screen.dart';
import 'package:bloc_chatapp/utils/app_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDPdKrtxmbNpotPfNgcw_NjiygZ8MbfNSs',
        appId: '1:916231263187:web:7a5aa3d32c5b30fca69526',
        messagingSenderId: '916231263187',
        projectId: 'chatapp-987ea',
        authDomain: 'chatapp-987ea.firebaseapp.com',
        storageBucket: 'chatapp-987ea.appspot.com',
        measurementId: 'G-F79DJ0VFGS',
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: primaryMaterialColor,
          primarySwatch: primaryMaterialColor,
          scaffoldBackgroundColor: Colors.white),
      home: const SplashScreen(),
      // home: BlocProvider(
      //   create: (context) => SignInBloc(),
      //   child: SignInScreen(),
      // ),
    );
  }
}
