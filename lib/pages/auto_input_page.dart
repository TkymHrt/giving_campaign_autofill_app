import 'package:flutter/material.dart';
import 'package:giving_campaign_autofill_app/utils/javascript_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/user_info.dart';
import '../services/storage_service.dart';
import '../widgets/user_info_modal.dart';

class AutoInputPage extends StatefulWidget {
  const AutoInputPage({super.key});

  @override
  _AutoInputPageState createState() => _AutoInputPageState();
}

class _AutoInputPageState extends State<AutoInputPage> {
  late WebViewController controller;
  UserInfo? userInfo;
  final TextEditingController _urlController = TextEditingController();
  String currentUrl = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final loadedUserInfo = await StorageService.getUserInfo();
    if (loadedUserInfo != null) {
      setState(() {
        userInfo = loadedUserInfo;
      });
    }
  }

  Future<void> _showUserInfoModal() async {
    await showDialog(
      context: context,
      builder: (context) => UserInfoModal(
        initialUserInfo: userInfo,
        onSave: (newUserInfo) async {
          await StorageService.saveUserInfo(newUserInfo);
          setState(() {
            userInfo = newUserInfo;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ユーザー情報を保存しました')),
            );
          }
        },
      ),
    );
  }

  void _initWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              currentUrl = url;
            });
          },
        ),
      );

    const defaultUrl = 'https://www.giving-campaign.jp/';
    controller.loadRequest(Uri.parse(defaultUrl));
  }

  Future<void> _loadUrl() async {
    String url = _urlController.text;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    try {
      await controller.loadRequest(Uri.parse(url));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('無効なURL: $e')),
      );
    }
  }

  Future<void> _injectAutoInputScript() async {
    if (userInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ユーザー情報が設定されていません')),
      );
      return;
    }
    try {
      await controller
          .runJavaScript(JavaScriptHelper.getAutoInputScript(userInfo!));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('スクリプトの実行に失敗しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Giving Campaign Autofill App',
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: _showUserInfoModal,
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'URLを入力してください',
                      ),
                      onSubmitted: (_) => _loadUrl(),
                    ),
                  ),
                  SizedBox(width: 8),
                  FilledButton(
                    onPressed: _loadUrl,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('開く'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userInfo != null
                                  ? '${userInfo!.lastName} ${userInfo!.firstName}'
                                  : 'ユーザー情報未設定',
                            ),
                            if (userInfo != null)
                              Text(
                                '${userInfo!.email}',
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  FilledButton(
                    onPressed: _injectAutoInputScript,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('自動入力を実行'),
                  ),
                ],
              ),
            ),
            if (isLoading) LinearProgressIndicator(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: WebViewWidget(controller: controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
