import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoedaModel {
  final String nome;
  final String valor;

  MoedaModel({required this.nome, required this.valor});
}

class MoedaPage extends StatefulWidget {
  const MoedaPage({Key? key}) : super(key: key);

  @override
  State<MoedaPage> createState() => _MoedaPageState();
}

class _MoedaPageState extends State<MoedaPage> {
  List<MoedaModel> moedas = [];
  bool _isMounted = false; // Adicionando uma flag para verificar se o widget está montado

  @override
  void initState() {
    super.initState();
    _isMounted = true; // Define a flag como true quando o widget é montado
    fetchData();
  }

  @override
  void dispose() {
    _isMounted = false; // Define a flag como false quando o widget é descartado
    super.dispose();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.hgbrasil.com/finance?key=8e09a4f6'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final currencies = jsonData['results']['currencies'];

      List<MoedaModel> newMoedas = [];
      currencies.forEach((key, value) {
        if (value is Map && value.containsKey('name') && value.containsKey('buy')) {
          final moeda = MoedaModel(nome: value['name'], valor: value['buy'].toString());
          newMoedas.add(moeda);
        }
      });

      // Atualizar o estado apenas se o widget estiver montado
      if (_isMounted) {
        setState(() {
          moedas = newMoedas;
        });
      }
    } else {
      print('Erro na solicitação: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: const Color.fromRGBO(3, 181, 170, 1),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Color.fromRGBO(12, 27, 51, 1),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: CupertinoScrollbar(
            child: moedas.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: moedas.length,
                    itemBuilder: (context, index) {
                      final moeda = moedas[index];
                      return ListTile(
                        title: Text(
                          moeda.nome,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Valor: ${moeda.valor}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

