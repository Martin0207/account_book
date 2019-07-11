import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model/account.dart';

class AddAccount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddState();
  }
}

class AddState extends State<AddAccount> {
  var _dateTime;
  int _typeValue;
  TextEditingController _moneyController;
  InputDecoration _moneyDecoration;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _moneyController = TextEditingController();
    _moneyDecoration = InputDecoration(
        hintText: '请输入记账金额',
        labelText: '记账金额',
        suffixText: '元',
        helperText: '最多两位小数');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Text('时间：'),
                  width: 60,
                ),
                OutlineButton(
                  child: Text(
                    _dateTime
                        .toString()
                        .substring(0, _dateTime.toString().lastIndexOf('.')),
                  ),
                  onPressed: () async {
                    await pickDateTime(context);
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: Text('类型：'),
                  width: 60,
                ),
                DropdownButton(
                  hint: Text('请选择账目类型'),
                  value: _typeValue,
                  items: AccountingType.getItems().map((item) {
                    return DropdownMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(AccountingType.getIcon(
                              AccountingType.getType(item))),
                          SizedBox(
                            width: 16,
                          ),
                          Text(item),
                        ],
                      ),
                      value: AccountingType.getType(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        _typeValue = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: Text('金额：'),
                  width: 60,
                ),
                SizedBox(
                  child: TextField(
                    controller: _moneyController,
                    decoration: _moneyDecoration,
                    maxLength: 7,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp('[0-9\.]')),
                    ],
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                  ),
                  width: 200,
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.fromLTRB(48, 32, 48, 32),
            child: RaisedButton(
              child: Text('添加'),
              onPressed: () {
                var money = double.tryParse(_moneyController.text.toString());
                if (money == null) {
                  Fluttertoast.showToast(msg: '请输入正确金额');
                  return;
                }
                int index = _moneyController.text.indexOf('.') + 1;
                if (index > 0 &&
                    _moneyController.text.substring(index).length > 2) {
                  print('小数部分: ${_moneyController.text.substring(index)}');
                  Fluttertoast.showToast(msg: '最多保留两位小数');
                  return;
                }
                var account = Account(_dateTime, _typeValue, money);
                account.insert();
                Fluttertoast.showToast(msg: '添加记录成功');
                Navigator.pop(context);
              },
              color: Colors.blue,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  ///选择日期时间
  Future pickDateTime(BuildContext context) async {
    var datePicked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(_dateTime.year - 1),
      lastDate: DateTime.now(),
    );
    if (datePicked != null) {
      TimeOfDay timePicked = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(_dateTime));
      if (timePicked != null) {
        setState(() {
          _dateTime = DateTime(
            datePicked.year,
            datePicked.month,
            datePicked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }
}
