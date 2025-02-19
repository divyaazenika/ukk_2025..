import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/Produk/indexproduk.dart';
import 'package:ukk_kasir/beranda.dart';
import 'package:ukk_kasir/detailpenjualan/index.dart';
import 'package:intl/intl.dart'; // Import intl package

class addproduk extends StatefulWidget {
  const addproduk({super.key});

  @override
  State<addproduk> createState() => _addprodukState();
}

class _addprodukState extends State<addproduk> {
  final TextEditingController NamaProdukController = TextEditingController();
  final TextEditingController HargaController = TextEditingController();
  final TextEditingController StokController = TextEditingController();
  final TextEditingController JumlahController = TextEditingController();  // Input untuk jumlah produk yang dibeli
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    NamaProdukController.dispose();
    HargaController.dispose();
    StokController.dispose();
    JumlahController.dispose();  // Dispose untuk JumlahController
    super.dispose();
  }

  // Format harga menjadi format dengan titik
  String formatHarga(int harga) {
    final formatter = NumberFormat('#,###');
    return formatter.format(harga);  // Format dengan ribuan pemisah
  }

  Future<void> tambahProduk() async {
    if (_formKey.currentState!.validate()) {
      final String NamaProduk = NamaProdukController.text.trim();
      final int? Harga = int.tryParse(HargaController.text.trim());
      final int? Stok = int.tryParse(StokController.text.trim());
      final int? Jumlah = int.tryParse(JumlahController.text.trim()); // Jumlah produk yang dibeli

      if (Harga == null || Stok == null || Jumlah == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harga, Stok, dan Jumlah harus berupa angka')),
        );
        return;
      }

      // Validasi agar jumlah yang dibeli tidak lebih dari stok yang tersedia
      if (Jumlah > Stok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jumlah pembelian tidak boleh melebihi stok yang tersedia')),
        );
        return;
      }

      try {
        final response = await Supabase.instance.client.from('produk').insert({
          'NamaProduk': NamaProduk,
          'Harga': Harga,
          'Stok': Stok,
        }).select();

        if (response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk Berhasil ditambahkan')),
          );

          // Update stok produk setelah penambahan
          final updatedStok = Stok - Jumlah;  // Mengurangi stok sesuai jumlah pembelian
          await Supabase.instance.client.from('produk').update({
            'Stok': updatedStok,
          }).eq('NamaProduk', NamaProduk);

          await Future.delayed(const Duration(seconds: 2));

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RiwayatPenjualan()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menambahkan produk')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: NamaProdukController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Produk Wajib Diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: HargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga Wajib Diisi';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Format harga saat diketik
                  final harga = int.tryParse(value);
                  if (harga != null) {
                    HargaController.value = HargaController.value.copyWith(
                      text: formatHarga(harga),  // Format harga dengan titik
                      selection: TextSelection.collapsed(offset: HargaController.text.length),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: StokController,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok Wajib Diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: JumlahController,  // Input jumlah yang dibeli
                decoration: const InputDecoration(
                  labelText: 'Jumlah Pembelian',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah Pembelian Wajib Diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Jumlah Pembelian harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: tambahProduk,
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
