import 'package:flutter/material.dart';
import 'package:ukk_kasir/registrasi/insertuser.dart';
import 'package:ukk_kasir/registrasi/updateuser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  List<Map<String, dynamic>> user = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchuser();
  }

  Future<void> deleteuser(int id) async {
    try {
      await Supabase.instance.client.from('user').delete().eq('Userid', id);
      fetchuser();
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> fetchuser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('user').select();
      setState(() {
        user = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Table'),
      ),
      body: isLoading
          ? Center(
            )
          : user.isEmpty
              ? Center(
                  child: Text(
                    'User belum ditambahkan',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    final plg = user[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: 180,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username: ${plg['username'] ?? 'tidak tersedia'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Password: ${plg['Password'] ?? 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Role: ${plg['role'] ?? 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.brown),
                                    onPressed: () {
                                      final Userid = plg['Userid'] ?? 0; // Pastikan ini sesuai dengan kolom di database
                                        if (Userid != 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdateUser(Userid: Userid)
                                            ),
                                          );
                                        } else {
                                          print('ID pelanggan tidak valid');
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.brown),
                                    onPressed: () {
                                      deleteuser(plg['Userid']);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              floatingActionButton: FloatingActionButton(onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserInsert()));
              },
              child: Icon(Icons.add),
              ),
    );
  }
}