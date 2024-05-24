import 'dart:ui';

import 'package:corretorasbrasil/models/broker_model.dart';
import 'package:corretorasbrasil/repositories/broker_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

extension FormatDayTime on DateTime {
  String formatDay() {
    return day < 10 ? '0$day' : day.toString();
  }
}

extension FormatMonthTime on DateTime {
  String formatMonth() {
    return month < 10 ? '0$month' : month.toString();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corretoras do Brasil',
      debugShowCheckedModeBanner:
          false, // tirar a flag de debug no canto superior direito da tela do app
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BrokerRepository _brokerRepository;
  late ValueNotifier<List<BrokerModel>> brokerList = ValueNotifier([]);

  bool loading = true;

  @override
  void initState() {
    _brokerRepository = BrokerRepository(dio: Dio());
    _initScreen();
    super.initState();
  }

  Future<void> _initScreen() async {
    loading = true;
    final listFromApi = await _brokerRepository.brokerReposit();
    brokerList.value.clear();
    brokerList.value.addAll(listFromApi
        .where((broker) => broker.status == 'EM FUNCIONAMENTO NORMAL'));
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(75.0),
            child: AppBar(
              toolbarHeight: 100.0,
              shadowColor: Colors.black,
              backgroundColor: const Color(0xFF0068FF),
              elevation: 2.0,
              centerTitle: true,
              title: const Text('Corretoras do Brasil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  )),
              leading: IconButton(
                icon: const Icon(Icons.account_balance_sharp,
                    color: Colors.white),
                onPressed: () {
                  _initScreen();
                  setState(() {});
                },
              ),
            )),
        body: SingleChildScrollView(
          child: loading
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 350),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: brokerList.value.length,
                  itemBuilder: (context, index) {
                    final BrokerModel broker = brokerList.value[index];
                    return Column(children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20.0,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    broker.nomeComercial.isEmpty ||
                                            broker.nomeComercial == '--'
                                        ? 'NOME COMERCIAL DESCONHECIDO.'
                                        : broker.nomeComercial,
                                    style: const TextStyle(
                                      color: Color(0xFF627179),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BackdropFilter(
                                          // widget para deixar o fundo do alertDialog com blur
                                          filter: ImageFilter.blur(
                                              sigmaX: 5.0, sigmaY: 5.0),
                                          child: AlertDialog(
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    broker.nomeSocial,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(broker.logradouro ==
                                                              null ||
                                                          broker.logradouro!
                                                              .isEmpty
                                                      ? 'Logradouro não informado.'
                                                      : broker.logradouro!),
                                                  Text(
                                                      'Bairro: ${broker.bairro == null || broker.bairro!.isEmpty ? 'bairro nao informado.' : broker.bairro!}'),
                                                  Text(
                                                      'CEP: ${broker.cep == null || broker.cep!.isEmpty ? 'CEP nao informado.' : broker.cep!}'),
                                                  Text(
                                                      'UF: ${broker.uf == null || broker.uf!.isEmpty ? 'UF nao informado.' : broker.uf!}'),
                                                  Text(
                                                    'e-mail: ${broker.email == null || broker.email!.isEmpty ? 'e-mail nao informado.' : broker.email!}',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.info_outline,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              broker.municipio.isEmpty
                                  ? 'CIDADE DESCONHECIDA'
                                  : broker.municipio,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Container(
                              height: 0.8,
                              width: double.infinity,
                              color: Colors.black,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CVM: ${broker.codigoCvm}'),
                                Text('CNPJ: ${broker.cnpj}'),
                                Text('REGISTRO EM: '
                                    '${broker.dataRegistro?.formatDay()}/${broker.dataRegistro?.formatMonth()}/${broker.dataRegistro?.year}'),
                                Text(
                                  'NAV: ${broker.valorPatrimonioLiquido != 0 ? NumberFormat.currency(
                                      locale: 'pt_BR',
                                      symbol: 'R\$',
                                    ).format(broker.valorPatrimonioLiquido) : 'NÃO INFORMADO'}',
                                  style: TextStyle(
                                    color: broker.valorPatrimonioLiquido > 0
                                        ? Colors.green
                                        : broker.valorPatrimonioLiquido == 0
                                            ? Colors.black
                                            : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }),
        ));
  }
}
