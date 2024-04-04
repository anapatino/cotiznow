import 'package:cotiznow/lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final String name;
  final String email;
  final List<DrawerItemConfig> itemConfigs;

  const CustomDrawer({
    Key? key,
    required this.name,
    required this.email,
    required this.itemConfigs,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late IconData drawerIcon;

  @override
  void initState() {
    super.initState();
    drawerIcon = Icons.close;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      child: Container(
        color: Palette.secondary,
        child: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                name: widget.name,
                email: widget.email,
                drawerIcon: drawerIcon,
                onDrawerIconPressed: () {
                  setState(() {
                    drawerIcon =
                        (drawerIcon == Icons.menu) ? Icons.close : Icons.menu;
                  });
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: ListView(
                  children: widget.itemConfigs
                      .map((config) => config.build(context))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  final String name;
  final String email;
  final IconData drawerIcon;
  final VoidCallback onDrawerIconPressed;

  DrawerHeader({
    Key? key,
    required this.name,
    required this.email,
    required this.drawerIcon,
    required this.onDrawerIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: 16.0, left: 16.0, bottom: 0.1, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  drawerIcon,
                  color: Colors.white,
                ),
                onPressed: onDrawerIconPressed,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.varelaRound(
                    fontSize: screenWidth * 0.069,
                    color: Colors.white,
                  ),
                ),
                Text(
                  email,
                  style: GoogleFonts.varelaRound(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItemConfig {
  final IconData icon;
  final String title;
  final String routeName;

  DrawerItemConfig({
    required this.icon,
    required this.title,
    required this.routeName,
  });

  void clearCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setString('name', "");
    await prefs.setString('lastName', "");
    await prefs.setString('phone', "");
    await prefs.setString('address', "");
    await prefs.setString('email', "");
    await prefs.setString('role', "");
    await prefs.setString('account', "");
    await prefs.setString('id', "");
    await prefs.setString('authId', "");
  }

  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.varelaRound(color: Colors.white),
      ),
      onTap: () {
        if (routeName == "/principal") {
          clearCache();
        }
        Get.offAllNamed(routeName);
      },
    );
  }
}
