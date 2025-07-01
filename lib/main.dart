import 'package:animated_scroll_view/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';


void main() {
  runApp(const MyCupertinoApp());
}

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Cupertino Demo',
      theme: CupertinoThemeData(
          brightness: Brightness.dark,
          barBackgroundColor: const Color.fromARGB(255, 161, 81, 81)),
      home: HomeScreen(),
    );
  }
}
