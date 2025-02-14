import 'package:flutter/material.dart';
import 'package:ukk_kasir/beranda.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.brown),
    home: MyHomePage(title: 'Beranda'),
  ));
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedOrderType;
  bool isberandaVisible = false;
  Map<String, int> cart = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 212, 106, 132),
        foregroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.shopping_bag, color: Colors.brown), text: 'Produk'),
            Tab(icon: Icon(Icons.person, color: Colors.white), text: 'penjualan'),
            
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['produk', 'Jenis buku', 'Costemers']
                  .map((label) => _buildCategoryButton(label))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(label),
    );
  }
}
