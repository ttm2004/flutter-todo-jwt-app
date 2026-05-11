import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_store.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _changePassword = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppStore>().userLogin;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final store = context.read<AppStore>();
    final err = await store.updateProfile(
      name: _nameCtrl.text.trim(),
      currentPassword: _changePassword ? _currentPasswordCtrl.text : null,
      newPassword: _changePassword ? _newPasswordCtrl.text : null,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (err == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cập nhật thông tin thành công'),
        backgroundColor: Colors.green,
      ));
      // Reset password fields
      _currentPasswordCtrl.clear();
      _newPasswordCtrl.clear();
      _confirmPasswordCtrl.clear();
      setState(() => _changePassword = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppStore>().userLogin;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text('Thông Tin Tài Khoản', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              CircleAvatar(
                radius: 48,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(user?.email ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 24),

              // Thông tin cơ bản
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Thông tin cơ bản',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Họ và tên',
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Vui lòng nhập tên';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email (readonly)
                      TextFormField(
                        initialValue: user?.email ?? '',
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Đổi mật khẩu
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Đổi mật khẩu',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Switch(
                            value: _changePassword,
                            onChanged: (v) => setState(() {
                              _changePassword = v;
                              if (!v) {
                                _currentPasswordCtrl.clear();
                                _newPasswordCtrl.clear();
                                _confirmPasswordCtrl.clear();
                              }
                            }),
                          ),
                        ],
                      ),

                      if (_changePassword) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _currentPasswordCtrl,
                          obscureText: _obscureCurrent,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu hiện tại',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureCurrent
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                            ),
                          ),
                          validator: (v) {
                            if (_changePassword && (v == null || v.isEmpty)) {
                              return 'Vui lòng nhập mật khẩu hiện tại';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _newPasswordCtrl,
                          obscureText: _obscureNew,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu mới',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureNew
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _obscureNew = !_obscureNew),
                            ),
                          ),
                          validator: (v) {
                            if (_changePassword) {
                              if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu mới';
                              if (v.length < 6) return 'Ít nhất 6 ký tự';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _confirmPasswordCtrl,
                          obscureText: _obscureConfirm,
                          decoration: InputDecoration(
                            labelText: 'Xác nhận mật khẩu mới',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                          validator: (v) {
                            if (_changePassword) {
                              if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
                              if (v != _newPasswordCtrl.text) return 'Mật khẩu xác nhận không khớp';
                            }
                            return null;
                          },
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        Text('Bật để thay đổi mật khẩu',
                            style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _save,
                  icon: _isLoading
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save_outlined),
                  label: const Text('Lưu thay đổi', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
