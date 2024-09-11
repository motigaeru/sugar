import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _imagePath;
  String? _errorMessage;
  bool _isLoggedIn = false;
  bool _isCreatingAccount = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await _profileService.isLoggedIn();
    if (loggedIn) {
      await _loadProfile();
    }
    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.getProfile();
    setState(() {
      _nameController.text = profile['name'] ?? '';
      _emailController.text = profile['email'] ?? '';
      _imagePath = profile['imagePath'];
    });
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      setState(() {
        _errorMessage = '名前とメールアドレスは必須です';
      });
      return;
    }

    await _profileService.saveProfile(
      _nameController.text,
      _emailController.text,
      _imagePath ?? '',
    );

    setState(() {
      _errorMessage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プロフィールが保存されました')),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Future<void> _createAccount() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'メールアドレスとパスワードを入力してください';
      });
      return;
    }

    await _profileService.saveCredentials(email, password);
    await _profileService.setLoggedIn(true);

    setState(() {
      _isLoggedIn = true;
      _isCreatingAccount = false;
      _errorMessage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('アカウントが作成されました')),
    );

    await _loadProfile();
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'メールアドレスとパスワードを入力してください';
      });
      return;
    }

    final loggedIn = await _profileService.login(email, password);
    if (loggedIn) {
      await _profileService.setLoggedIn(true);
      setState(() {
        _isLoggedIn = true;
        _errorMessage = null;
      });
      await _loadProfile();
    } else {
      setState(() {
        _errorMessage = 'ログインに失敗しました。メールアドレスまたはパスワードが違います。';
      });
    }
  }

  Future<void> _logout() async {
    await _profileService.logout();
    setState(() {
      _isLoggedIn = false;
      _nameController.clear();
      _emailController.clear();
      _imagePath = null;
    });
  }

  Future<void> _confirmAccountDeletion() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('アカウント削除の確認'),
          content: const Text('本当にアカウントを削除しますか？この操作は取り消せません。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // ダイアログを閉じる
                await _deleteAccount();
              },
              child: const Text(
                '削除',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    await _profileService.deleteAccount();
    setState(() {
      _isLoggedIn = false;
      _nameController.clear();
      _emailController.clear();
      _imagePath = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('アカウントが削除されました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Align(
          alignment: Alignment.centerLeft,
          child: const Text('プロフィール'),
        ),
        backgroundColor: const Color.fromARGB(255, 227, 227, 23),
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (_isLoggedIn) ...[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imagePath != null
                      ? FileImage(File(_imagePath!))
                      : const AssetImage('assets/default_avatar.png') as ImageProvider,
                  child: _imagePath == null
                      ? const Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '名前'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'メールアドレス'),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('保存'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmAccountDeletion,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('アカウントを削除'),
              ),
            ] else ...[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'メールアドレス'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isCreatingAccount ? _createAccount : _login,
                child: Text(_isCreatingAccount ? 'アカウントを作成' : 'ログイン'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isCreatingAccount = !_isCreatingAccount;
                  });
                },
                child: Text(_isCreatingAccount
                    ? '既にアカウントをお持ちですか？ '
                    : 'アカウントをお持ちでないですか？ '),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
