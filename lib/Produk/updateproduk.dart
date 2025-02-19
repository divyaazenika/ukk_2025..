import 'package:flutter/material.dart';
import 'package:ukk_kasir/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/beranda.dart';


class UpdateProduk extends StatefulWidget {
  final Map<String, dynamic> produk;
  final Function refreshProduk;
  UpdateProduk({required this.produk, required this.refreshProduk});

  @override
  _UpdateProdukState createState() => _UpdateProdukState();
}

class _UpdateProdukState extends State<UpdateProduk> {
  final SupabaseClient supabase = Supabase.instance.client;
  late TextEditingController namaController;
  late TextEditingController hargaController;
  late TextEditingController stokController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.produk['NamaProduk']);
    hargaController = TextEditingController(text: widget.produk['Harga'].toString());
    stokController = TextEditingController(text: widget.produk['Stok'].toString());
  }

  Future<void> updateProduk() async {
    final nama = namaController.text.trim();
    final harga = int.tryParse(hargaController.text.trim()) ?? 0;
    final stok = int.tryParse(stokController.text.trim()) ?? 0;

    if (nama.isEmpty || harga <= 0 || stok < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data tidak valid')));
      return;
    }

    await supabase.from('produk').update({'NamaProduk': nama, 'Harga': harga, 'Stok': stok}).eq('ProdukID', widget.produk['ProdukID']);
    widget.refreshProduk();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: namaController, decoration: InputDecoration(labelText: 'Nama Produk')),
            TextField(controller: hargaController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            TextField(controller: stokController, decoration: InputDecoration(labelText: 'Stok'), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ElevatedButton(onPressed: updateProduk, child: Text('Update')),
          ],
        ),
      ),
    );
  }
}
