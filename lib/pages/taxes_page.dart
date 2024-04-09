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

class TaxModel {
  final String date;
  final double cdi;
  final double selic;

  TaxModel({
    required this.date,
    required this.cdi,
    required this.selic,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
      date: json['date'] as String,
      cdi: (json['cdi'] as num).toDouble(),
      selic: (json['selic'] as num).toDouble(),
    );
  }
}

class TaxesPage extends StatefulWidget {
  const TaxesPage({Key? key}) : super(key: key);

  @override
  State<TaxesPage> createState() => _TaxesPageState();
}

class _TaxesPageState extends State<TaxesPage> {
  late Future<Map<String, dynamic>> futureTaxes;

  @override
  void initState() {
    super.initState();
    futureTaxes = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(3, 181, 170, 1),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(12, 27, 51, 1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          margin: const EdgeInsets.all(15),
          child: Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: futureTaxes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final List<dynamic> taxesData = snapshot.data!['results']['taxes'] as List<dynamic>;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: taxesData.map((tax) {
                        final taxModel = TaxModel.fromJson(tax as Map<String, dynamic>);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Data: ${taxModel.date}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'CDI: ${taxModel.cdi}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Selic: ${taxModel.selic}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
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
