import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/pelanggan/insertpelanggan.dart';
import 'package:ukk_kasir/pelanggan/updatepelanggan.dart';

class PelangganIndex extends StatefulWidget {
  @override
  _PelangganIndexState createState() => _PelangganIndexState();
}

class _PelangganIndexState extends State<PelangganIndex> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pelanggan = [];
  List<Map<String, dynamic>> filteredPelanggan = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    final response = await supabase.from('pelanggan').select();
    setState(() {
      pelanggan = List<Map<String, dynamic>>.from(response);
      filteredPelanggan = pelanggan; // Inisialisasi daftar yang difilter
    });
  }

  void filterPelanggan(String query) {
    setState(() {
      filteredPelanggan = pelanggan
          .where((item) =>
              item['NamaPelanggan'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> deletePelanggan(int id) async {
    await supabase.from('pelanggan').delete().eq('PelangganID', id);
    fetchPelanggan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Pelanggan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Cari Pelanggan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterPelanggan,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPelanggan.length,
              itemBuilder: (context, index) {
                final item = filteredPelanggan[index];
                return ListTile(
                  title: Text(item['NamaPelanggan']),
                  subtitle: Text('Alamat: ${item['Alamat']} | Telepon: ${item['NomorTelepon']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePelanggan(
                              pelanggan: item,
                              refreshPelanggan: fetchPelanggan,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.brown),
                        onPressed: () => deletePelanggan(item['PelangganID']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InsertPelanggan(refreshPelanggan: fetchPelanggan),
          ),
        ),
      ),
    );
  }
}