import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async {
  final response = await http.get(Uri.parse('https://api.hgbrasil.com/finance?key=8e09a4f6'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    return jsonData;
  } else {
    throw Exception('Failed to load bitcoin data');
  }
}

class BitcoinModel {
  final String name;
  final String valor;

  const BitcoinModel({
    required this.name,
    required this.valor,
  });

  factory BitcoinModel.fromJson(Map<String, dynamic> json) {
    return BitcoinModel(
      name: json['name'] as String,
      valor: json['last'].toString(),
    );
  }
}


class BitcoinPage extends StatefulWidget {
  const BitcoinPage({super.key});

  @override
  State<BitcoinPage> createState() => _BitcoinPage();
}

class _BitcoinPage extends State<BitcoinPage> {
  late Future<Map<String, dynamic>> futureBitcoin;

  @override
  void initState() {
    super.initState();
    futureBitcoin = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(3, 181, 170,1),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color.fromRGBO(12, 27, 51,1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          margin: EdgeInsets.all(15),
          child: Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: futureBitcoin,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final bitcoinData = snapshot.data!['results']['bitcoin'] as Map<String, dynamic>;
                  final List<Widget> bitcoinWidget = [];
                  bitcoinData.forEach((key, value) {
                    final bitcoin = BitcoinModel.fromJson(value);
                    bitcoinWidget.add(ListTile(
                      title: Text(
                        '${bitcoin.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Valor: ${bitcoin.valor}',
                            style: TextStyle(
                            color: Colors.white,
                        ),
                            ),
                        ],
                      ),
                    ));
                  });
                  return ListView(
                    children: bitcoinWidget,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
