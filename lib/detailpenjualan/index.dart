import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/beranda.dart';

class RiwayatPenjualan extends StatefulWidget {
  @override
  _RiwayatPenjualanState createState() => _RiwayatPenjualanState();
}

class _RiwayatPenjualanState extends State<RiwayatPenjualan> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> penjualan = [];

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    final response = await supabase.from('penjualan').select();
    setState(() {
      penjualan = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<List<Map<String, dynamic>>> fetchDetailPenjualan(int penjualanID) async {
    final response = await supabase
        .from('detail_penjualan')
        .select('ProdukID, JumlahProduk, Subtotal, produk(NamaProduk, Harga)')
        .eq('PenjualanID', penjualanID);

    return List<Map<String, dynamic>>.from(response.map((item) => {
          'NamaProduk': item['produk']['NamaProduk'],
          'Harga': item['produk']['Harga'],
          'JumlahProduk': item['JumlahProduk'],
          'Subtotal': item['Subtotal'],
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Penjualan")),
      body: penjualan.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: penjualan.length,
              itemBuilder: (context, index) {
                final item = penjualan[index];
                return ListTile(
                  title: Text("Penjualan ${item['PenjualanID']}"),
                  subtitle: Text("Total: Rp ${item['TotalHarga']}"),
                  onTap: () async {
                    List<Map<String, dynamic>> detailProduk =
                        await fetchDetailPenjualan(item['PenjualanID']);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RiwayatPenjualan(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}