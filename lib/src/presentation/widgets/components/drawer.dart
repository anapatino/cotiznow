import 'package:cotiznow/lib.dart';

class CustomDrawer extends StatelessWidget {
  final String name;
  final String email;
  final List<DrawerItemConfig> itemConfigs;
  final BuildContext context;

  const CustomDrawer({
    super.key,
    required this.name,
    required this.email,
    required this.itemConfigs,
    required this.context,
  });

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
                name: name,
                email: email,
              ),
              Expanded(
                child: ListView(
                  children: itemConfigs
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

  const DrawerHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
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

  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.varelaRound(color: Colors.white),
      ),
      onTap: () {
        Get.offAllNamed(routeName);
      },
    );
  }
}
