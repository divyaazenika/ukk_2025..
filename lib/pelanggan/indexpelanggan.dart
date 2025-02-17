import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/beranda.dart';
import 'package:ukk_kasir/Produk/insertproduk.dart';
import 'package:ukk_kasir/pelanggan/insertpelanggan.dart';
import 'updatepelanggan.dart';

class Indexpelanggan extends StatefulWidget {
  const Indexpelanggan({super.key});

  @override
  State<Indexpelanggan> createState() => _indexpelangganState();
}

class _indexpelangganState extends State<Indexpelanggan> {
  //buat variabel untuk menyimpan daftar pelanggan
  List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  //fungsi untuk mengambil data pelanggan dari supabase
  Future<void> fetchPelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pelanggan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletePelanggan(int id) async {
    try {
      await Supabase.instance.client
        .from('pelanggan')
        .delete()
        .eq('PelangganID', id);
      fetchPelanggan();
    } catch (e) {
      print('Error deleting pelanggan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
      ? Center(
      )
      : pelanggan.isEmpty
      ? Center(
        child: Text(
          'Tidak ada pelanggan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
      : ListView.builder(
        itemCount: pelanggan.length,
        itemBuilder: (context, index) {
          final langgan = pelanggan[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langgan['NamaPelanggan'] ??'Pelanggan tidak tersedia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    langgan['Alamat'] ?? 'Alamat Tidak tersedia',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    langgan['NomorTelepon'] ?? 'Tidak tersedia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,color: Colors.blueAccent),
                        onPressed: () {
                          final PelangganID = langgan['PelangganID'] ??0; // Pastikan ini sesuai dengan kolom di database
                            if (PelangganID != 0) {
                              Navigator.push(
                                context,MaterialPageRoute(
                                  builder: (context) => updatePelanggan(PelangganID: PelangganID)
                                )
                              );
                            } else {
                              print('ID pelanggan tidak valid');
                            }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.brown),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Hapus Pelanggan'),
                                content: const Text('Apakah Anda yakin ingin menghapus pelanggan ini?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal')
                                  ),
                                  TextButton(onPressed: () {
                                    deletePelanggan(langgan['PelangganID']);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Hapus'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Insertpelanggan())
          );
        },
        child: Icon(Icons.add, color: Colors.brown[2500],)
      )
    );
  }
}