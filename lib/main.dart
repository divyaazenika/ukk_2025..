import 'package:flutter/material.dart';
import 'beranda.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Pastikan mengimpor layar beranda di sini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      //url dan anonkey dari supabase
      url:  'https://dbxmbtmnbukghijkwhxu.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRieG1idG1uYnVrZ2hpamt3aHh1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYzODQ5NzAsImV4cCI6MjA1MTk2MDk3MH0.SVpjIYFIqFxNPMaQeaxB7jefIGGimEnLmcW39AoFg38');
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Halaman Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controller untuk username dan password
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Membuat formKey untuk validasi form
  final formKey = GlobalKey<FormState>();

  // Fungsi untuk menangani login
  Future<void> _login() async {
    // Validasi form sebelum menavigasi
    if (formKey.currentState?.validate() ?? false) {
      // Navigasi ke layar beranda setelah login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Beranda()), // Navigasi ke halaman beranda
      );
    } else {
      // Tampilkan pesan kesalahan jika form tidak valid
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Mohon lengkapi form dengan benar!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gambar
                Image.asset(
                  'assets/coffe.png',
                  height: 135,
                  width: 135,
                ),
                SizedBox(height: 20),
                Text(
                  'Halaman Login',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 212, 170, 154),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _login, // Menangani login
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
