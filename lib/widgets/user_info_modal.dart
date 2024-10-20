import 'package:flutter/material.dart';

import '../models/user_info.dart';

class UserInfoModal extends StatefulWidget {
  final UserInfo? initialUserInfo;
  final Function(UserInfo) onSave;

  const UserInfoModal({
    super.key,
    this.initialUserInfo,
    required this.onSave,
  });

  @override
  _UserInfoModalState createState() => _UserInfoModalState();
}

class _UserInfoModalState extends State<UserInfoModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _kanaLastNameController;
  late TextEditingController _kanaFirstNameController;
  late TextEditingController _emailController;
  late TextEditingController _telController;
  String _gender = '男性';
  late int _birthYear;
  late int _birthMonth;
  late int _birthDay;

  @override
  void initState() {
    super.initState();
    final info = widget.initialUserInfo;
    _lastNameController = TextEditingController(text: info?.lastName ?? '');
    _firstNameController = TextEditingController(text: info?.firstName ?? '');
    _kanaLastNameController =
        TextEditingController(text: info?.kanaLastName ?? '');
    _kanaFirstNameController =
        TextEditingController(text: info?.kanaFirstName ?? '');
    _emailController = TextEditingController(text: info?.email ?? '');
    _telController = TextEditingController(text: info?.tel ?? '');
    _gender = info?.gender ?? '男性';
    _birthYear = info?.birthYear ?? 2000;
    _birthMonth = info?.birthMonth ?? 1;
    _birthDay = info?.birthDay ?? 1;
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _kanaLastNameController.dispose();
    _kanaFirstNameController.dispose();
    _emailController.dispose();
    _telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ユーザー情報設定',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: '姓',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? '姓を入力してください' : null,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: '名',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? '名を入力してください' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _kanaLastNameController,
                        decoration: InputDecoration(
                          labelText: 'せい',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'セイを入力してください' : null,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _kanaFirstNameController,
                        decoration: InputDecoration(
                          labelText: 'めい',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'メイを入力してください' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'メールアドレス',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'メールアドレスを入力してください';
                    if (!value!.contains('@')) return '有効なメールアドレスを入力してください';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _telController,
                  decoration: InputDecoration(
                    labelText: '電話番号',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? '電話番号を入力してください' : null,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('性別: '),
                    Radio<String>(
                      value: '男性',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value!),
                    ),
                    Text('男性'),
                    Radio<String>(
                      value: '女性',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value!),
                    ),
                    Text('女性'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _birthYear,
                        decoration: InputDecoration(
                          labelText: '年',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(100, (index) => 2024 - index)
                            .map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text('$year'),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _birthYear = value!),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _birthMonth,
                        decoration: InputDecoration(
                          labelText: '月',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(12, (index) => index + 1)
                            .map((month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text('$month'),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _birthMonth = value!),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _birthDay,
                        decoration: InputDecoration(
                          labelText: '日',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            List.generate(31, (index) => index + 1).map((day) {
                          return DropdownMenuItem(
                            value: day,
                            child: Text('$day'),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _birthDay = value!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('キャンセル'),
                    ),
                    SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final userInfo = UserInfo(
                            lastName: _lastNameController.text,
                            firstName: _firstNameController.text,
                            kanaLastName: _kanaLastNameController.text,
                            kanaFirstName: _kanaFirstNameController.text,
                            email: _emailController.text,
                            tel: _telController.text,
                            gender: _gender,
                            birthYear: _birthYear,
                            birthMonth: _birthMonth,
                            birthDay: _birthDay,
                          );
                          widget.onSave(userInfo);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('保存'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
