import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'halaman_profile.dart';

// ============================================================
// HALAMAN LOGIN & REGISTER 
// ============================================================
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Untuk toggle antara Login / Register
  bool isLogin = true;

  // Controller untuk input teks
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  // State
  bool loading = false;
  String? pesanError;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  // -- Fungsi Register --
  Future<void> _register() async {
    setState(() {
      loading = true;
      pesanError = null;
    });

    final res = await AuthService.register(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passCtrl.text,
    );

    if (!mounted) return;

    if (res['success'] == true) {
      await AuthService.simpanToken(res['data']['token']);
      _keHalamanProfil();
    } else {
      setState(() {
        pesanError = res['message'] ?? 'Registrasi gagal';
        loading = false;
      });
    }
  }

  // -- Fungsi Login --
  Future<void> _login() async {
    setState(() {
      loading = true;
      pesanError = null;
    });

    final res = await AuthService.login(
      email: emailCtrl.text.trim(),
      password: passCtrl.text,
    );

    if (!mounted) return;

    if (res['success'] == true) {
      await AuthService.simpanToken(res['data']['token']);
      _keHalamanProfil();
    } else {
      setState(() {
        pesanError = res['message'] ?? 'Login gagal';
        loading = false;
      });
    }
  }

  // -- Pindah ke halaman profil --
  void _keHalamanProfil() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.teal),
              const SizedBox(height: 8),
              Text(
                isLogin ? 'Masuk' : 'Daftar Akun',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // --- Field Nama (hanya untuk Register) ---
              if (!isLogin)
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
              if (!isLogin) const SizedBox(height: 12),

              // --- Field Email ---
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // --- Field Password ---
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              // --- Pesan Error ---
              if (pesanError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    pesanError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // --- Tombol Login / Register ---
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : (isLogin ? _login : _register),
                  child: loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isLogin ? 'Masuk' : 'Daftar', style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),

              // --- Toggle Login / Register ---
              TextButton(
                onPressed: () => setState(() {
                  isLogin = !isLogin;
                  pesanError = null;
                }),
                child: Text(
                  isLogin ? 'Belum punya akun? Daftar' : 'Sudah punya akun? Masuk',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
