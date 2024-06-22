part of report_measure;

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int currentPos = 0;
  int index = 0;
  final List<Widget> screens = [
    const HomePage(),
     NewAssessmentPage(),
     NewAssessmentPage(),
     NewAssessmentPage(),
  ];

  var destinations = [
    NavigationDestination(
      selectedIcon: SvgPicture.asset(Assets.icons.home, color: kOrange700),
      icon: SvgPicture.asset(Assets.icons.home, color: kGrey100),
      label: '',
    ),
    NavigationDestination(
      selectedIcon: SvgPicture.asset(Assets.icons.patient, color: kOrange700),
      icon: SvgPicture.asset(Assets.icons.patient, color: kGrey100),
      label: '',
    ),
    NavigationDestination(
      selectedIcon: SvgPicture.asset(Assets.icons.document, color: kOrange700),
      icon: SvgPicture.asset(Assets.icons.document, color: kGrey100),
      label: '',
    ),
    NavigationDestination(
      selectedIcon: SvgPicture.asset(Assets.icons.settings, color: kOrange700),
      icon: SvgPicture.asset(Assets.icons.settings),
      label: '',
    ),

    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      bottomNavigationBar: Container(
        decoration:
            const BoxDecoration(border: Border(top: BorderSide(width: .05))),
        child: NavigationBarTheme(
          data: const NavigationBarThemeData(
            backgroundColor: kWhite,
            indicatorColor: Colors.transparent,
          ),
          child: NavigationBar(
            height: 80,
            backgroundColor: kWhite,
            elevation: 0,
            indicatorColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            selectedIndex: index,
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
            destinations: destinations,
          ),
        ),
      ),
      body: screens[index],
    );
  }
}
