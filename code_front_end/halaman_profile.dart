import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'halaman_login_regiter.dart';


// ============================================================
// HALAMAN PROFIL (setelah Login/Register)
// ============================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _ambilProfil();
  }

  Future<void> _ambilProfil() async {
    final res = await AuthService.getProfile();

    if (!mounted) return;

    if (res['success'] == true) {
      setState(() {
        user = res['data']['user'];
        loading = false;
      });
    } else {
      // Token expired / tidak valid → kembali ke login
      await AuthService.hapusToken();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
      );
    }
  }

  Future<void> _logout() async {
    await AuthService.hapusToken();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Keluar',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade100,
                      child: Text(
                        (user?['name'] ?? '?')[0].toUpperCase(),
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nama
                    Text(
                      user?['name'] ?? '-',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Email
                    Text(
                      user?['email'] ?? '-',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),

                    // Tanggal daftar
                    Text(
                      'Bergabung: ${user?['created_at'] ?? '-'}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
