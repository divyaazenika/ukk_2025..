import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/penjualan/indexpenjualan.dart';
import 'package:ukk_kasir/penjualan/insert.dart';

class DetailProduk extends StatefulWidget {
  final Map<String, dynamic> produk;

  DetailProduk({required this.produk});

  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController jumlahController = TextEditingController();
  int pelangganID = 1; // **Ganti dengan ID pelanggan yang login**

  Future<void> pesanProduk() async {
    int jumlahBeli = int.tryParse(jumlahController.text.trim()) ?? 0;
    int stokTersedia = widget.produk['Stok'];
    double hargaSatuan = widget.produk['Harga'];
    double totalHarga = jumlahBeli * hargaSatuan;

    // Validasi jumlah beli
    if (jumlahBeli <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Jumlah beli harus lebih dari 0")));
      return;
    }
    if (jumlahBeli > stokTersedia) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Jumlah beli tidak boleh melebihi stok tersedia")));
      return;
    }

    // 1. **Simpan ke tabel penjualan (membuat transaksi baru)**
    final penjualanResponse = await supabase.from('penjualan').insert({
      'TanggalPenjualan': DateTime.now().toIso8601String(),
      'TotalHarga': totalHarga,
      'PelangganID': pelangganID,
    }).select();

    if (penjualanResponse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal membuat transaksi!")));
      return;
    }

    // Ambil `PenjualanID` dari transaksi yang baru dibuat
    int penjualanID = penjualanResponse.first['PenjualanID'];

    // 2. **Simpan ke tabel detail_penjualan (jika ada tabel ini)**
    await supabase.from('detail_penjualan').insert({
      'PenjualanID': penjualanID,
      'ProdukID': widget.produk['ProdukID'],
      'Jumlah': jumlahBeli,
      'TotalHarga': totalHarga,
    });

    // 3. **Kurangi stok produk**
    await supabase.from('produk').update({
      'Stok': stokTersedia - jumlahBeli,
    }).eq('ProdukID', widget.produk['ProdukID']);

    // 4. **Tampilkan notifikasi & kembali**
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pesanan berhasil!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.produk['NamaProduk'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.produk['NamaProduk'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Harga: Rp ${widget.produk['Harga']}", style: TextStyle(fontSize: 18)),
            Text("Stok: ${widget.produk['Stok']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextField(
              controller: jumlahController,
              decoration: InputDecoration(
                labelText: "Jumlah Beli",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Kembali"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context)=> PenjualanIndex()),);
                  },
                  child: Text("Pesan"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}