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
    throw Exception('Failed to load stock data');
  }
}

class StockModel {
  final String name;
  final double points;
  final double variation;

  const StockModel({
    required this.name,
    required this.points,
    required this.variation,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      name: json['name'] as String,
      points: (json['points'] as num).toDouble(),
      variation: (json['variation'] as num).toDouble(),
    );
  }
}


class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPage();
}

class _StockPage extends State<StockPage> {
  late Future<Map<String, dynamic>> futureStocks;

  @override
  void initState() {
    super.initState();
    futureStocks = fetchData();
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
              future: futureStocks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final stocksData = snapshot.data!['results']['stocks'] as Map<String, dynamic>;
                  final List<Widget> stockWidgets = [];
                  stocksData.forEach((key, value) {
                    final stock = StockModel.fromJson(value);
                    stockWidgets.add(ListTile(
                      title: Text(
                        '${stock.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pontos: ${stock.points}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            ),
                          Text(
                            'Variação: ${stock.variation}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            ),
                        ],
                      ),
                    ));
                  });
                  return ListView(
                    children: stockWidgets,
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
