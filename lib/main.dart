import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: 'https://oxzvmzutcofwvqpyepey.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94enZtenV0Y29md3ZxcHllcGV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDkyNTIsImV4cCI6MjA1NDk4NTI1Mn0.iEDbyaok5p0qgLaQrzxxXJZGu_VEbORxyi2RR8P4GEs',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Flutter Demo Home Page'), // This is where the title is passed
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
  // Controllers for username and password fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Create formKey to validate the form
  final formKey = GlobalKey<FormState>();

  // Function to handle login
  Future<void> _login() async {
    // No validation, just navigate to the next screen (Beranda)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: '')), // Navigate directly to Beranda
    );
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
                // Image
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
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Just proceed to the next screen
                          _login();
                        },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage(title: 'Beranda')),
          );
        },
      ),
    );
  }
}
