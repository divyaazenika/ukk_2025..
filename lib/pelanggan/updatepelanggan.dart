import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdatePelanggan extends StatefulWidget {
  final Map<String, dynamic> pelanggan;
  final Function refreshPelanggan;
  UpdatePelanggan({required this.pelanggan, required this.refreshPelanggan});

  @override
  _UpdatePelangganState createState() => _UpdatePelangganState();
}

class _UpdatePelangganState extends State<UpdatePelanggan> {
  final SupabaseClient supabase = Supabase.instance.client;
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController teleponController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.pelanggan['NamaPelanggan']);
    alamatController = TextEditingController(text: widget.pelanggan['Alamat']);
    teleponController = TextEditingController(text: widget.pelanggan['NomorTelepon']);
  }

  Future<void> updatePelanggan() async {
    final nama = namaController.text.trim();
    final alamat = alamatController.text.trim();
    final telepon = teleponController.text.trim();

    if (nama.isEmpty || alamat.isEmpty || telepon.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data tidak boleh kosong')));
      return;
    }

    await supabase
        .from('pelanggan')
        .update({'NamaPelanggan': nama, 'Alamat': alamat, 'NomorTelepon': telepon})
        .eq('PelangganID', widget.pelanggan['PelangganID']);

    widget.refreshPelanggan();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Pelanggan')),
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
            ElevatedButton(onPressed: updatePelanggan, child: Text('Update')),
          ],
        ),
      ),
    );
  }
}