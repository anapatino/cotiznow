import 'package:cotiznow/lib.dart';

class IconList {
  static List<Map<String, dynamic>> get icons {
    return [
      {
        "icon": "Icons.calendar_view_week_outlined",
        "title": "",
      },
      {
        "icon": "Icons.auto_awesome_mosaic_outlined",
        "title": "",
      },
      {
        "icon": "Icons.door_front_door_outlined",
        "title": "",
      },
      {
        "icon": "Icons.add_home_work_outlined",
        "title": "",
      },
      {
        "icon": "Icons.all_inbox_outlined",
        "title": "",
      },
      {
        "icon": "Icons.amp_stories_outlined",
        "title": "",
      },
      {
        "icon": "Icons.aspect_ratio_rounded",
        "title": "",
      },
      {
        "icon": "Icons.bento_outlined",
        "title": "",
      },
      {
        "icon": "Icons.carpenter_outlined",
        "title": "",
      },
    ];
  }

  static IconData getIconDataFromString(String iconString) {
    switch (iconString) {
      case "Icons.calendar_view_week_outlined":
        return Icons.calendar_view_week_outlined;
      case "Icons.auto_awesome_mosaic_outlined":
        return Icons.auto_awesome_mosaic_outlined;
      case "Icons.door_front_door_outlined":
        return Icons.door_front_door_outlined;
      case "Icons.add_home_work_outlined":
        return Icons.add_home_work_outlined;
      case "Icons.all_inbox_outlined":
        return Icons.all_inbox_outlined;
      case "Icons.amp_stories_outlined":
        return Icons.amp_stories_outlined;
      case "Icons.aspect_ratio_rounded":
        return Icons.aspect_ratio_rounded;
      case "Icons.bento_outlined":
        return Icons.bento_outlined;
      case "Icons.carpenter_outlined;":
        return Icons.carpenter_outlined;

      default:
        return Icons.category_outlined;
    }
  }
}
