import 'package:flutter/material.dart';
// import 'package:kasirr/admin/home_admin.dart';
import 'package:ukk_kasir/beranda.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/pelanggan/updatepelanggan.dart';
import 'package:ukk_kasir/penjualan/insert.dart';
import 'package:ukk_kasir/penjualan/updatepenjualan.dart';

class IndexPenjualan extends StatefulWidget {
  const IndexPenjualan({super.key});

  @override
  State<IndexPenjualan> createState() => _IndexPenjualanState();
}

class _IndexPenjualanState extends State<IndexPenjualan> {
  List<Map<String, dynamic>> penjualan = [];

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    try {
      final response =
          await Supabase.instance.client.from('penjualan').select();
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching penjualan: $e');
    }
  }

  Future<void> deletePenjualan(int id) async {
    try {
      await Supabase.instance.client
          .from('penjualan')
          .delete()
          .eq('PenjualanID', id);
      fetchPenjualan();
    } catch (e) {
      print('Error deleting penjualan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
      ),
      body: Container(
        color: Colors.white,
        child: penjualan.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada Riwayat Penjualan',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: penjualan.length,
                itemBuilder: (context, index) {
                  final langgan = penjualan[index];
                  return SizedBox(
                    height: 145,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    langgan['TanggalPenjualan'] ?? 'Tidak tersedia',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    langgan['TotalHarga']?.toString() ?? 'Tidak tersedia',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    langgan['PelangganID']?.toString() ?? 'Tidak tersedia',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.brown, size: 28),
                                      onPressed: () {
                                        final PenjualanID = langgan['PenjualanID'] ?? 0;
                                        if (PenjualanID != 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdatePenjualan(PenjualanID: PenjualanID),
                                            ),
                                          );
                                        } else {
                                          print('ID Penjualan tidak valid');
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Color(0xFF8D6E63)),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Hapus Produk'),
                                              content: const Text(
                                                  'Apakah Anda yakin ingin menghapus produk ini?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deletePenjualan(langgan['PenjualanID']);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Hapus',
                                                    style: TextStyle(
                                                    ),
                                                  ),
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const InsertPenjualan()));
        },
        backgroundColor: Colors.brown[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
