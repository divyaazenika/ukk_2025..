import 'package:flutter/material.dart';
import 'package:ukk_kasir/Produk/indexproduk.dart';
import 'package:ukk_kasir/detailpenjualan/index.dart';
import 'package:ukk_kasir/main.dart';
import 'package:ukk_kasir/pelanggan/indexpelanggan.dart';
import 'package:ukk_kasir/penjualan/indexpenjualan.dart';
import 'package:ukk_kasir/registrasi/adminhomepage.dart';

class Beranda extends StatefulWidget {
  final cart;
  const Beranda({super.key, this.cart});

  @override
  State<Beranda> createState() => _homepageState();
}

class _homepageState extends State<Beranda> {
  // GlobalKey untuk Scaffold agar dapat membuka drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey, // Set key untuk Scaffold
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.inventory, color: Colors.white),
                child: Text('Produk',
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
              Tab(
                icon: Icon(Icons.people, color: Colors.white),
                child: Text('Pelanggan',
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
              Tab(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                child: Text('Penjualan',
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
              Tab(
                icon: Icon(Icons.account_balance_wallet, color: Colors.white),
                child: Text('Detail Penjualan',
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ],
            // labelColor: Colors.red,
          ),
          backgroundColor: Colors.brown[300],
          foregroundColor: Colors.white,
          title: const Text('Beranda'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu), // Ikon menu untuk membuka drawer
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer(); // Membuka drawer menggunakan key
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white), // Menambahkan ikon pencarian
              onPressed: () {
                // Logika pencarian bisa ditambahkan di sini
                print('Search icon clicked');
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.brown[300],
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Beranda'),
                onTap: () {
                  Navigator.pop(context); // Menutup drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.app_registration),
                title: Text('Registrasi'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHomePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: '',),
                    ),
                  ); // Navigasi ke halaman awal
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children:  [divyaproduk(), 
                      Indexpelanggan(),
                      IndexPenjualan(),
                      IndexDetail(),
                      ],
        ),
      ),
    );
  }
}
