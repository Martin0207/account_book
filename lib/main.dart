import 'dart:async';

import 'package:flutter/material.dart';
import 'event/event_bus.dart';
import 'package:account_book/model/account.dart';
import 'add_account.dart';
import 'constant/routes.dart';
import 'constant/constant.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Account book'),
      routes: {
        ADD_ACCOUNT: (context) {
          return AddAccount();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _amount = 0.0;
  List<Account> _items;
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  void init() async {
    await refresh();
    if (_streamSubscription == null)
      _streamSubscription = eventBus.on<AddEvent>().listen((event) {
        print('收到发送的信息');
        refresh();
      });
  }

  refresh() async {
    _amount = 0.0;
    _items = await queryAccountList();
    if (_items != null) {
      _items.forEach((item) {
        _amount += item.money;
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
//              refresh();
              eventBus.fire(AddEvent());
            },
            icon: Icon(Icons.filter),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Total Amount: "),
                    Text(
                      _amount.toString(),
                      style: TextStyle(fontSize: 40, color: Colors.redAccent),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            padding: EdgeInsets.all(8),
          ),
          Divider(),
          ListView(
            shrinkWrap: true,
            children: getItems(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).pushNamed(ADD_ACCOUNT);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> getItems() {
    if (_items == null || _items.length == 0) {
      return List.of([
        Container(
          height: 240,
          child: Column(
            children: <Widget>[
              Icon(Icons.hourglass_empty),
              SizedBox(
                height: 40,
              ),
              Text('暂无数据'),
            ],
          ),
        )
      ]);
    } else {
      List<Widget> items = List();
      int dLength = _items.length * 2;
      for (var i = 0; i < dLength; i++) {
        if (i.isOdd) {
          items.add(Divider());
        } else {
          var item = _items[i ~/ 2];
          items.add(ListTile(
            title: Text(AccountingType.getName(item.type)),
            subtitle: Text(
              '${item.money}元',
              style: TextStyle(color: Colors.redAccent),
            ),
            leading: Icon(
              AccountingType.getIcon(item.type),
              color: Colors.blue,
            ),
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Tips'),
                          content: Text('确定删除该条记账记录?'),
                          actions: <Widget>[
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                item.setDelete();
                              },
                              child: Text('确定',style: TextStyle(
                                color: Colors.blue
                              ),),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('取消'),
                            ),
                          ],
                        );
                      });
                }),
          ));
        }
      }
      return items;
    }
  }
}
