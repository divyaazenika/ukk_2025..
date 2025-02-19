import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertPenjualan extends StatefulWidget {
  final Function refreshPenjualan;
  InsertPenjualan({required this.refreshPenjualan});

  @override
  _InsertPenjualanState createState() => _InsertPenjualanState();
}

class _InsertPenjualanState extends State<InsertPenjualan> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController totalHargaController = TextEditingController();
  final TextEditingController pelangganIDController = TextEditingController();

  Future<void> addPenjualan() async {
    final tanggal = tanggalController.text.trim();
    final totalHarga = double.tryParse(totalHargaController.text.trim()) ?? 0;
    final pelangganID = int.tryParse(pelangganIDController.text.trim()) ?? 0;

    if (tanggal.isEmpty || totalHarga <= 0 || pelangganID <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data tidak valid')));
      return;
    }

    await supabase.from('penjualan').insert({
      'TanggalPenjualan': tanggal,
      'TotalHarga': totalHarga,
      'PelangganID': pelangganID,
    });

    widget.refreshPenjualan();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Penjualan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: tanggalController, decoration: InputDecoration(labelText: 'Tanggal Penjualan')),
            TextField(controller: totalHargaController, decoration: InputDecoration(labelText: 'Total Harga'), keyboardType: TextInputType.number),
            TextField(controller: pelangganIDController, decoration: InputDecoration(labelText: 'Pelanggan ID'), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ElevatedButton(onPressed: addPenjualan, child: Text('Tambah')),
          ],
        ),
      ),
    );
  }
}