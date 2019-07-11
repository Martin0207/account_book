import 'package:flutter/material.dart';

///记账类型
class AccountingType {
  ///饮食
  static const DIET = 0;

  ///娱乐
  static const PLAY = 1;

  ///办公
  static const OFFICE = 2;

  ///其他
  static const OTHER = 3;

  ///根据类型状态值获取类型名
  static String getName(int type) {
    var name;
    switch (type) {
      case DIET:
        name = "饮食";
        break;
      case PLAY:
        name = "娱乐";
        break;
      case OFFICE:
        name = "办公";
        break;
      case OTHER:
        name = "其他";
        break;
    }
    return name;
  }

  ///根据类型名获取类型状态值
  static int getType(String name) {
    var type;
    switch (name) {
      case '饮食':
        type = DIET;
        break;
      case '娱乐':
        type = PLAY;
        break;
      case '办公':
        type = OFFICE;
        break;
      case '其他':
        type = OTHER;
        break;
    }
    return type;
  }

  ///获取类型集合
  static List<String> getItems() {
    return List.of(['饮食', "娱乐", "办公", "其他"]);
  }

  ///获取图标
  static getIcon(int type) {
    var icon = Icons.mood_bad;
    switch (type) {
      case DIET:
        icon = Icons.local_drink;
        break;
      case PLAY:
        icon = Icons.queue_play_next;
        break;
      case OFFICE:
        icon = Icons.work;
        break;
      case OTHER:
        icon = Icons.devices_other;
        break;
    }
    return icon;
  }
}

///数据库名称
class DataBaseName {
  ///账目
  static const ACCOUNT = 'account';
}
