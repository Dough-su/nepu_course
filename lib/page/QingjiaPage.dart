import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:muse_nepu_course/util/global.dart';

class QingjiaPage extends StatefulWidget {
  static const ThemeMode themeMode = ThemeMode.light;

  @override
  _QingjiaPageState createState() => _QingjiaPageState();
}

class _QingjiaPageState extends State<QingjiaPage> {
  List<String> _selectedValues = [];
  TextEditingController _passwordController = TextEditingController();

  Future<void> _deleteSelectedRecords() async {
    final dio = Dio();
    final formData = FormData.fromMap({
      'pd_mm': Global.xgc_password,
      'uname': Global.jwc_xuehao,
      'id': _selectedValues,
    });

    try {
      final response = await dio.post(
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/del_qingjia',
        data: formData,
      );

      print(response.data);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _savePassword() {
    String password = _passwordController.text;
    setState(() {
      Global.xgc_password = password;
    });
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Global.home_currentcolor,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('请假管理'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('设置密码'),
                      content: TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: '学工处密码',
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('取消'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _passwordController.clear();
                          },
                        ),
                        TextButton(
                          child: const Text('保存'),
                          onPressed: () {
                            _savePassword();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Global.xgc_password == ''
            ?  Column(
          children: [
            Text('请先设置学工处密码'),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '学工处密码',
              ),
            ),
            TextButton(
              child: const Text('保存'),
              onPressed: _savePassword,
            ),
          ],
        )
            : Column(
          children: [
            MultiSelectDropDown.network(
              hint: '请选择请假记录',
              alwaysShowOptionIcon: true,
              onOptionSelected: (options) {
                setState(() {
                  //只要其中的values
                  _selectedValues = options.map((e) => e.value!).toList();
                  print(_selectedValues);
                });
              },
              networkConfig: NetworkConfig(
                url:
                'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/history?uname=${Global.jwc_xuehao}&pd_mm=${Global.xgc_password}',
                method: RequestMethod.get,
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              responseParser: (response) {
                try {
                  final list = (response as List<dynamic>).map((e) {
                    final item = e as Map<String, dynamic>;
                    return ValueItem(
                      label: item['LXMC'] +
                          " " +
                          item['QJSY'] +
                          " " +
                          item['KSSJ'] +
                          " " +
                          item['SHZTMC'] +
                          " " +
                          item['SHJGMC'],
                      value: item['ID'],
                    );
                  }).toList();

                  return Future.value(list);
                } catch (e) {
                  AchievementView(
                      title: "错误!",
                      subTitle: '您的学工处密码不对哦',
                      color: Colors.red,
                      duration: Duration(seconds: 4),
                      isCircle: true,
                      listener: (status) {})
                    ..show(context);
                  return Future.value([]);
                }
              },
              responseErrorBuilder: ((context, body) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Error fetching the data'),
                );
              }),
            ),
            //删除按钮
            IconButton(
              tooltip: '删除选中记录',
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedRecords,
            ),
          ],
        ),
      ),
    );
  }
}