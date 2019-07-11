import 'package:account_book/dao/dao_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:account_book/constant/constant.dart';
import 'package:uuid/uuid.dart';
import 'package:event_bus/event_bus.dart';
import 'package:account_book/event/event_bus.dart';

Future<List<Account>> queryAccountList() async {
  Database db = await getDB();

  List<Map> list = await db.query(DataBaseName.ACCOUNT, where: 'isDelete = 0');

  return list.map((item) {
    var account =
        Account(DateTime.parse(item['dateTime']), item['type'], item['money']);
    account.id = item['id'];
    account.delete = item['isDelete'] == 1;
    return account;
  }).toList();
}

///账目Model
class Account {
  ///Id
  String id;

  ///时间
  DateTime dateTime;

  ///类型
  int type;

  ///是否删除
  bool delete;

  ///金额
  double money;

  Account(this.dateTime, this.type, this.money) {
    id = Uuid().v4();
    delete = false;
  }

  insert() async {
    var db = await getDB();
    db.transaction((txn) async {
      await txn.rawInsert("""
      INSERT INTO account
      (id,dateTime,type,isDelete,money)
      VALUES
      ("$id","$dateTime",$type,${delete ? 1 : 0},$money)
      """);
    });
    db.close();
    eventBus.fire(AddEvent());
  }

  setDelete() async {
    var db = await getDB();
    db.update(DataBaseName.ACCOUNT, {'isDelete': 1}, where: 'id = "$id"');
    db.close();
    eventBus.fire(AddEvent());
  }
}
