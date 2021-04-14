import 'package:Dissertation/utilities/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeModel>(
            create: (BuildContext context) => ThemeModel(),
          ),
        ],
        // child: DevicePreview(
        //   enabled: false,
        //   builder: (context) => MyApp(),
        // ),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: DevicePreview.appBuilder,
      title: 'COVID-19 & Pneumonia Diagnosis',
      theme: Provider.of<ThemeModel>(context).currentTheme,
      initialRoute: Routes.homeView,
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
