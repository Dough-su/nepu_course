import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:muse_nepu_course/widget/qingjia_button.dart';

class PaymentBottomSheet extends StatefulWidget {
  final detail; // 添加detail变量作为成员变量
  final int index;

  const PaymentBottomSheet(
      {super.key, required this.detail, required this.index});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final TextEditingController qssjController = TextEditingController();
  final TextEditingController jssjCardsController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  //联系人
  final TextEditingController contactController = TextEditingController();

  //联系人电话
  final TextEditingController contactPhoneController = TextEditingController();

  //学工处密码
  final TextEditingController xgcPasswordController = TextEditingController();
  int? selectqssjCard = 0;
  int? selectedjssjCard = 0;
  int? category = 0;

  @override
  void initState() {
    super.initState();
    categoryController.text = '事假';
    qssjController.text = widget.detail[widget.index]['qssj'];
    jssjCardsController.text = widget.detail[widget.index]['jssj'];
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardsEntries = <DropdownMenuEntry<int>>[];
    final categoryEntries = <DropdownMenuEntry<int>>[];
    List<String> items = [];
    categoryEntries.addAll([
      DropdownMenuEntry<int>(
        value: 1,
        label: '事假',
      ),
      DropdownMenuEntry<int>(
        value: 2,
        label: '病假',
      ),
    ]);
    cardsEntries.addAll([
      DropdownMenuEntry<int>(
        value: 1,
        label: '8:00:00',
      ),
      DropdownMenuEntry<int>(value: 2, label: '9:35:00'),
      DropdownMenuEntry<int>(value: 3, label: '9:55:00'),
      DropdownMenuEntry<int>(value: 4, label: '11:30:00'),
      DropdownMenuEntry<int>(value: 5, label: '13:30:00'),
      DropdownMenuEntry<int>(value: 6, label: '15:05:00'),
      DropdownMenuEntry<int>(value: 7, label: '15:25:00'),
      DropdownMenuEntry<int>(value: 8, label: '17:00:00'),
      DropdownMenuEntry<int>(value: 9, label: '18:00:00'),
      DropdownMenuEntry<int>(value: 10, label: '19:35:00'),
      DropdownMenuEntry<int>(value: 11, label: '19:55:00'),
      DropdownMenuEntry<int>(value: 12, label: '21:30:00'),
    ]);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + bottomInset + 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),

          DropdownMenu<int>(
            controller: categoryController,
            width: MediaQuery.of(context).size.width - 20 * 2,
            leadingIcon: const Icon(Icons.credit_card),
            label: const Text('请假类别'),
            initialSelection: category,
            dropdownMenuEntries: categoryEntries,
            onSelected: (int? index) {
              setState(() {
                category = index;
              });
            },
          ),
          const SizedBox(height: 20),

          DropdownMenu<int>(
            controller: qssjController,
            leadingIcon: const Icon(Icons.credit_card),
            width: MediaQuery.of(context).size.width - 20 * 2,
            label: const Text('请假时间'),
            initialSelection: selectqssjCard,
            dropdownMenuEntries: cardsEntries,
            onSelected: (int? index) {
              setState(() {
                selectqssjCard = index;
              });
            },
          ),
          const SizedBox(height: 20),

          DropdownMenu<int>(
            controller: jssjCardsController,
            leadingIcon: const Icon(Icons.credit_card),
            width: MediaQuery.of(context).size.width - 20 * 2,
            label: const Text('结束时间'),
            initialSelection: selectedjssjCard,
            dropdownMenuEntries: cardsEntries,
            onSelected: (int? index) {
              setState(() {
                selectedjssjCard = index;
              });
            },
          ),

          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(hintText: '请假原因'),
            controller: reasonController,
          ),
          const SizedBox(height: 20),

          FoldableFields(
            qssjController: qssjController,
            jssjCardsController: jssjCardsController,
            categoryController: categoryController,
            reasonController: reasonController,
            contactController: contactController,
            contactPhoneController: contactPhoneController,
            xgcPasswordController: xgcPasswordController,
          ),
          const SizedBox(height: 20),

          MultiSelectDropDown.network(
            hint: '请选择抄送的老师',
            searchEnabled: true,
            onOptionSelected: (options) {
              //只要value
              items.clear();
              items.addAll(options.map((e) => e.value.toString()));
            },
            networkConfig: NetworkConfig(
              url:
                  'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/teacher',
              method: RequestMethod.get,
              headers: {
                'Content-Type': 'application/json',
              },
            ),
            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
            responseParser: (response) {
              final list = (response as List<dynamic>).map((e) {
                final item = e as Map<String, dynamic>;
                return ValueItem(
                  label: item['text'],
                  value: item['id'].toString(),
                );
              }).toList();

              return Future.value(list);
            },
            responseErrorBuilder: ((context, body) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Error fetching the data'),
              );
            }),
          ),
          const SizedBox(height: 20),
          QingjiaButton(
            enabled: true,
            width: screenSize.width - 20 * 2,
            qsrq: widget.detail[widget.index]['jsrq'],
            qssj: widget.detail[widget.index]['qssj'],
            jssj: widget.detail[widget.index]['jssj'],
            jsrq: widget.detail[widget.index]['jsrq'],
            qjsy: reasonController.text,
            chaosong: //提取抄送老师的id
                items,
            qjlx: categoryController.text == '事假' ? '01' : '02',
          ),

          const SizedBox(height: 20),
          //抄送给老师吗
        ],
      ),
    );
  }
}

class FoldableFields extends StatefulWidget {
  final TextEditingController qssjController;
  final TextEditingController jssjCardsController;
  final TextEditingController categoryController;
  final TextEditingController reasonController;
  final TextEditingController contactController;
  final TextEditingController contactPhoneController;
  final TextEditingController xgcPasswordController;

  const FoldableFields({
    required this.qssjController,
    required this.jssjCardsController,
    required this.categoryController,
    required this.reasonController,
    required this.contactController,
    required this.contactPhoneController,
    required this.xgcPasswordController,
    Key? key,
  }) : super(key: key);

  @override
  _FoldableFieldsState createState() => _FoldableFieldsState();
}

class _FoldableFieldsState extends State<FoldableFields> {
  bool _folded = Global.xgc_password == '' ? false : true;

  @override
  void initState() {
    super.initState();
    widget.contactController.text = Global.contact;
    widget.contactPhoneController.text = Global.contact_phone;
    widget.xgcPasswordController.text = Global.xgc_password;
    //监听联系人，联系人电话，学工处密码，如果有变化，就设置global变量
    widget.contactController.addListener(() {
      print(widget.contactController.text);
      Global.contact = widget.contactController.text;
    });
    widget.contactPhoneController.addListener(() {
      Global.contact_phone = widget.contactPhoneController.text;
    });
    widget.xgcPasswordController.addListener(() {
      Global.xgc_password = widget.xgcPasswordController.text;
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Text(_folded ? '显示个人信息' : '隐藏个人信息'),
          onPressed: () {
            setState(() {
              _folded = !_folded;
            });
          },
        ),
        if (!_folded)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        decoration: InputDecoration(hintText: '联系人'),
                        controller: widget.contactController),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                        decoration: InputDecoration(hintText: '联系人电话'),
                        controller: widget.contactPhoneController),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                  decoration: InputDecoration(hintText: '学工处密码，默认为身份证后6位'),
                  controller: widget.xgcPasswordController),
            ],
          ),
      ],
    );
  }
}
