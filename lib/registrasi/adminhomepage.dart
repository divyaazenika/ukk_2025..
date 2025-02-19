import 'package:flutter/material.dart';
import 'package:ukk_kasir/pelanggan/indexpelanggan.dart';
import 'package:ukk_kasir/Produk/indexproduk.dart';
import 'package:ukk_kasir/beranda.dart';
import 'package:ukk_kasir/penjualan/indexpenjualan.dart';
import 'package:ukk_kasir/registrasi/indexuser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/registrasi/insertuser.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.drafts, color: Color.fromARGB(255, 121, 99, 75)), text: 'Detail Penjualan'),
              Tab(icon: Icon(Icons.inventory, color: Color.fromARGB(255, 121, 99, 75)), text: 'Produk'),
              Tab(icon: Icon(Icons.people, color: Color.fromARGB(255, 121, 99, 75)), text: 'Customer'),
              Tab(icon: Icon(Icons.money, color: Color.fromARGB(255, 121, 99, 75)), text: 'Penjualan'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  child: ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text(
                      'Pengaturan dan Aktivitas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminHomePage()),
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Register'),
                onTap: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => UserTab())
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text('Laporan'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Pengaturan'),
              ),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Beranda()));
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProdukIndex(),
            PelangganIndex(),
            PenjualanIndex(),
          ],
        ),
      ),
    );
  }
}