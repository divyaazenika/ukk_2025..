import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ukk_kasir/detailpenjualan/index.dart';
import 'package:intl/intl.dart';  // Tambahkan import ini

class StrukPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedProduk;
  final int totalHarga;

  // Constructor untuk menerima parameter
  StrukPage({required this.selectedProduk, required this.totalHarga});

  // Fungsi untuk memformat harga dengan titik pemisah ribuan
  String formatCurrency(int amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  // Fungsi untuk membuat PDF
  Future<void> _generateAndDownloadPDF() async {
    final pdf = pw.Document();

    // Menambahkan konten ke PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Coffe time', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Jl. Raya No. 123, Kota XYZ', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.Text('Produk yang Dibeli', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              // Daftar produk yang dibeli
              ...selectedProduk.map((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    // Menampilkan jumlah di sebelah kiri
                    pw.Text('Jumlah: ${item['JumlahProduk']}', style: pw.TextStyle(fontSize: 14)),
                    pw.SizedBox(width: 16), // Memberikan ruang antara jumlah dan nama produk
                    // Menampilkan NamaProduk
                    pw.Expanded(child: pw.Text(item['NamaProduk'], style: pw.TextStyle(fontSize: 14))),
                    // Menampilkan harga produk dengan format pemisah ribuan
                    pw.Text('${formatCurrency(item['Harga'] * item['JumlahProduk'])}', style: pw.TextStyle(fontSize: 14)),
                  ],
                );
              }).toList(),
              pw.Divider(),
              // Menampilkan total harga
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Harga', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  // Menampilkan total harga dengan format pemisah ribuan
                  pw.Text('${formatCurrency(totalHarga)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(),
              // Menambahkan kata-kata tambahan setelah total harga
              pw.Center(
                child: pw.Text(
                  'Terima kasih atas kunjungan Anda! Semoga hari Anda menyenankan.',
                  style: pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.italic),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Menyimpan PDF dan mengunduhnya
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'struk_belanja.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Struk Belanja'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan informasi toko
            Text(
              'coffe time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            SizedBox(height: 8),
            Text(
              'Jl. Raya No. 123, Kota XYZ',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 16),
            Divider(),

            // Menampilkan daftar produk yang dibeli
            Text(
              'Produk yang Dibeli',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: selectedProduk.map((item) {
                  return ListTile(
                    title: Text(item['NamaProduk']),
                    subtitle: Text('Jumlah: ${item['JumlahProduk']}'),
                    trailing: Text('${formatCurrency(item['Harga'] * item['JumlahProduk'])}'),
                  );
                }).toList(),
              ),
            ),

            Divider(),

            // Menampilkan total harga
            ListTile(
              title: Text('Total Harga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Text('${formatCurrency(totalHarga)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Divider(),

            // Menambahkan kata-kata tambahan setelah total harga
            Center(
              child: Text(
                'Terimakasih sudah order dicaffe kami.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),

            // Tombol untuk menghasilkan dan mengunduh PDF
            ElevatedButton(
              onPressed: _generateAndDownloadPDF,
              child: Text('Unduh Struk (PDF)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
            SizedBox(height: 16),

            // Tombol "Selesai" yang mengarahkan ke halaman detail penjualan
            ElevatedButton(
              onPressed: () {
                // Arahkan ke halaman detail penjualan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RiwayatPenjualan()), // Ganti dengan halaman yang sesuai
                );
              },
              child: Text('Selesai'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
