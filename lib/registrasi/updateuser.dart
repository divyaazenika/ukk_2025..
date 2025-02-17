import 'package:flutter/material.dart';
import 'package:ukk_kasir/registrasi/indexuser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/registrasi/indexuser.dart';

class UpdateUser extends StatefulWidget {
  final int Userid;

  const UpdateUser({super.key, required this.Userid});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _user = TextEditingController();
  final _password = TextEditingController();
  final _role = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  // Fetch user details based on Userid
  Future<void> fetchUserDetails() async {
    try {
      final response = await Supabase.instance.client
          .from('user')
          .select()
          .eq('Userid', widget.Userid)
          .single();
      setState(() {
        _user.text = response['username'] ?? '';
        _password.text = response['Password']?.toString() ?? '';
        _role.text = response['role'] ?? '';
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // Update user data in database
  Future<void> updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('user').update({
          'username': _user.text,
          'Password': _password.text,
          'pole': _role.text
        }).eq('Userid', widget.Userid);

        // Navigate back to UserTab
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserTab()),
        );
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _user,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Password hidden
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _role,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Role tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateUserData,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}