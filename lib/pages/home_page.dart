import 'package:flutter/material.dart';
import 'package:flutter_finance_app/pages/bitcoin_page.dart';
import 'package:flutter_finance_app/pages/moeda_page.dart';
import 'package:flutter_finance_app/pages/stock_page.dart';
import 'package:flutter_finance_app/pages/taxes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState(){
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina){
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'App financeiro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1, 
          ),
          ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Cotação'),
              onTap: () {
                setState(() {
                  paginaAtual = 0;
                  pc.jumpToPage(paginaAtual);
                });
                Navigator.pop(context); // Fecha o Drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.currency_bitcoin),
              title: Text('Bitcoins'),
              onTap: () {
                setState(() {
                  paginaAtual = 1;
                  pc.jumpToPage(paginaAtual);
                });
                Navigator.pop(context); // Fecha o Drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.graphic_eq),
              title: Text('Ações'),
              onTap: () {
                setState(() {
                  paginaAtual = 2;
                  pc.jumpToPage(paginaAtual);
                });
                Navigator.pop(context); // Fecha o Drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_rounded),
              title: Text('Taxas'),
              onTap: () {
                setState(() {
                  paginaAtual = 3;
                  pc.jumpToPage(paginaAtual);
                });
                Navigator.pop(context); // Fecha o Drawer
              },
            ),
          ],
        ),
      ),
      body: PageView(
        children: [
          MoedaPage(),
          BitcoinPage(),
          StockPage(),
          TaxesPage(),
        ],
        controller: pc,
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.attach_money),label: 'Cotação'),
          BottomNavigationBarItem(icon: Icon(Icons.currency_bitcoin),label: 'Bitcoins'),
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq),label: 'Ações'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_rounded),label: 'Taxas'),

        ],
        onTap: (pagina){
          pc.animateToPage(pagina, duration: Duration(milliseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }
  
}