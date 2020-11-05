import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

enum TabItem {
  home,
  contact,
}

class TabItemData {
  const TabItemData({@required this.icon});

  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(icon: EvaIcons.homeOutline),
    TabItem.contact: TabItemData(icon: EvaIcons.phoneCallOutline),
  };
}
