import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdatePenjualan extends StatefulWidget {
  final Map<String, dynamic> penjualan;
  final Function refreshPenjualan;

  UpdatePenjualan({required this.penjualan, required this.refreshPenjualan});

  @override
  _UpdatePenjualanState createState() => _UpdatePenjualanState();
}

class _UpdatePenjualanState extends State<UpdatePenjualan> {
  final SupabaseClient supabase = Supabase.instance.client;
  late TextEditingController tanggalController;
  late TextEditingController totalHargaController;
  late TextEditingController pelangganIDController;

  @override
  void initState() {
    super.initState();
    tanggalController = TextEditingController(text: widget.penjualan['TanggalPenjualan']);
    totalHargaController = TextEditingController(text: widget.penjualan['TotalHarga'].toString());
    pelangganIDController = TextEditingController(text: widget.penjualan['PelangganID'].toString());
  }

  Future<void> updatePenjualan() async {
    final tanggal = tanggalController.text.trim();
    final totalHarga = double.tryParse(totalHargaController.text.trim()) ?? 0;
    final pelangganID = int.tryParse(pelangganIDController.text.trim()) ?? 0;

    if (tanggal.isEmpty || totalHarga <= 0 || pelangganID <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data tidak valid')));
      return;
    }

    await supabase.from('penjualan').update({
      'TanggalPenjualan': tanggal,
      'TotalHarga': totalHarga,
      'PelangganID': pelangganID,
    }).eq('PenjualanID', widget.penjualan['PenjualanID']);

    widget.refreshPenjualan();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Penjualan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: tanggalController, decoration: InputDecoration(labelText: 'Tanggal Penjualan')),
            TextField(controller: totalHargaController, decoration: InputDecoration(labelText: 'Total Harga'), keyboardType: TextInputType.number),
            TextField(controller: pelangganIDController, decoration: InputDecoration(labelText: 'Pelanggan ID'), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ElevatedButton(onPressed: updatePenjualan, child: Text('Update')),
          ],
        ),
      ),
    );
  }
}