import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertPelanggan extends StatefulWidget {
  final Function refreshPelanggan;
  InsertPelanggan({required this.refreshPelanggan});

  @override
  _InsertPelangganState createState() => _InsertPelangganState();
}

class _InsertPelangganState extends State<InsertPelanggan> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  Future<void> addPelanggan() async {
    final nama = namaController.text.trim();
    final alamat = alamatController.text.trim();
    final telepon = teleponController.text.trim();

    if (nama.isEmpty || alamat.isEmpty || telepon.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data tidak boleh kosong')));
      return;
    }

    await supabase.from('pelanggan').insert({
      'NamaPelanggan': nama,
      'Alamat': alamat,
      'NomorTelepon': telepon,
    });

    widget.refreshPelanggan();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Pelanggan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: namaController, decoration: InputDecoration(labelText: 'Nama Pelanggan')),
            TextField(controller: alamatController, decoration: InputDecoration(labelText: 'Alamat')),
            TextField(
              controller: teleponController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: addPelanggan, child: Text('Tambah')),
          ],
        ),
      ),
    );
  }
}