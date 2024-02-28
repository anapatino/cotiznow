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
      {
        "icon": "Icons.backup_table",
        "title": "",
      },
      {
        "icon": "Icons.barcode_reader",
        "title": "",
      },
      {
        "icon": "Icons.border_all_rounded",
        "title": "",
      },
      {
        "icon": "Icons.brush_rounded",
        "title": "",
      },
      {
        "icon": "Icons.build_rounded",
        "title": "",
      },
      {
        "icon": "Icons.construction_rounded",
        "title": "",
      },
      {
        "icon": "Icons.countertops_outlined",
        "title": "",
      },
      {
        "icon": "Icons.curtains_outlined",
        "title": "",
      },
      {
        "icon": "Icons.flashlight_on_outlined",
        "title": "",
      },
      {
        "icon": "Icons.format_paint_outlined",
        "title": "",
      },
      {
        "icon": "Icons.grid_on",
        "title": "",
      },
      {
        "icon": "Icons.handyman_outlined",
        "title": "",
      },
      {
        "icon": "Icons.hardware_outlined",
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
      case "Icons.carpenter_outlined":
        return Icons.carpenter_outlined;
      case "Icons.backup_table":
        return Icons.backup_table;
      case "Icons.barcode_reader":
        return Icons.barcode_reader;
      case "Icons.border_all_rounded":
        return Icons.border_all_rounded;
      case "Icons.brush_rounded":
        return Icons.brush_rounded;
      case "Icons.build_rounded":
        return Icons.build_rounded;
      case "Icons.construction_rounded":
        return Icons.construction_rounded;
      case "Icons.countertops_outlined":
        return Icons.countertops_outlined;
      case "Icons.curtains_outlined":
        return Icons.curtains_outlined;
      case "Icons.flashlight_on_outlined":
        return Icons.flashlight_on_outlined;
      case "Icons.format_paint_outlined":
        return Icons.format_paint_outlined;
      case "Icons.grid_on":
        return Icons.grid_on;
      case "Icons.handyman_outlined":
        return Icons.handyman_outlined;
      case "Icons.hardware_outlined":
        return Icons.hardware_outlined;

      default:
        return Icons.category_outlined;
    }
  }
}
