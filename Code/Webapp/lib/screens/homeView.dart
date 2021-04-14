import 'package:Dissertation/screens/landscape/webHome.dart';
import 'package:Dissertation/screens/mobileHome.dart';
import 'package:Dissertation/utilities/index.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      viewModel: HomeViewModel(),
      onModelReady: (model) => model.initialise(),
      child: ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: (context) => MyHomePagePortrait(
            title: 'COVID-19 Detection',
          ),
          landscape: (context) => MyHomePage(
            title: 'COVID-19 Detection',
          ),
        ),
        tablet: OrientationLayout(
          portrait: (context) => MyHomePagePortrait(
            title: 'COVID-19 Detection',
          ),
          landscape: (context) => MyHomePage(
            title: 'COVID-19 Detection',
          ),
        ),
        desktop: OrientationLayout(
          portrait: (context) => MyHomePagePortrait(
            title: 'COVID-19 Detection',
          ),
          landscape: (context) => MyHomePage(
            title: 'COVID-19 Detection',
          ),
        ),
      ),
    );
  }
}
