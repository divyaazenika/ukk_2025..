import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/Penjualan/strukbelanja.dart';// Pastikan import StrukBelanjaPage

class PenjualanIndex extends StatefulWidget {
  @override
  _PenjualanIndexState createState() => _PenjualanIndexState();
}

class _PenjualanIndexState extends State<PenjualanIndex> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> produk = [];
  List<Map<String, dynamic>> selectedProduk = []; // Produk yang dipilih

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    final response = await supabase.from('produk').select();
    setState(() {
      produk = List<Map<String, dynamic>>.from(response);
    });
  }

  // Toggle checkbox dan mengelola jumlah produk
  void toggleSelection(Map<String, dynamic> item, bool isSelected, {int quantity = 1}) {
    setState(() {
      if (isSelected) {
        selectedProduk.add({...item, 'JumlahProduk': quantity});
      } else {
        selectedProduk.removeWhere((p) => p['produkID'] == item['produkID']);
      }
    });
  }

  // Mengupdate jumlah produk
  void updateQuantity(Map<String, dynamic> item, int quantity) {
  setState(() {
    // Pastikan jumlah produk tidak kurang dari 1
    if (quantity >= 1) {
      final index = selectedProduk.indexWhere((p) => p['produkID'] == item['produkID']);
      if (index != -1) {
        selectedProduk[index]['JumlahProduk'] = quantity; // Update jumlah produk
      }
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pilih Produk')),
      body: ListView.builder(
        itemCount: produk.length,
        itemBuilder: (context, index) {
          final item = produk[index];
          bool isSelected = selectedProduk.any((p) => p['produkID'] == item['produkID']);
          int quantity = isSelected
              ? selectedProduk.firstWhere((p) => p['produkID'] == item['produkID'])['JumlahProduk']
              : 1;

          return ListTile(
            title: Text(item['NamaProduk']),
            subtitle: Text('Harga: Rp ${item['Harga']} | Stok: ${item['Stok']}'),
            trailing: isSelected
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 0) {
                            updateQuantity(item, quantity - 1);
                          }
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          updateQuantity(item, quantity + 1);
                        },
                      ),
                    ],
                  )
                : IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () => toggleSelection(item, true, quantity: quantity),
                  ),
            onTap: () {
              // Menampilkan dialog untuk memilih jumlah produk
              if (isSelected) {
                toggleSelection(item, false);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    int selectedQty = 1;
                    return AlertDialog(
                      title: Text('Masukkan Jumlah Produk'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Jumlah:'),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              selectedQty = int.tryParse(value) ?? 1;
                            },
                            decoration: InputDecoration(hintText: 'Jumlah produk'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            toggleSelection(item, true, quantity: selectedQty);
                            Navigator.pop(context);
                          },
                          child: Text('Konfirmasi'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Batal'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
  onPressed: selectedProduk.isEmpty
      ? null // Nonaktifkan jika tidak ada yang dipilih
      : () {
          // Menghitung total harga
          int totalHarga = selectedProduk.fold(0, (sum, item) {
            int harga = item['Harga'] ?? 0;
            int jumlah = item['JumlahProduk'] ?? 0;
            return sum + (harga * jumlah);
          });

          // Pindah ke halaman StrukPage dengan membawa data yang diperlukan
           Navigator.push(
            context,
           MaterialPageRoute(
      builder: (context) => StrukPage(selectedProduk: selectedProduk, totalHarga: totalHarga),       
           ),
           );
        },
  label: Text("Lanjutkan"),
  icon: Icon(Icons.shopping_cart),
  backgroundColor: selectedProduk.isEmpty ? Colors.grey : Colors.brown,
     ),

    );
  }
}