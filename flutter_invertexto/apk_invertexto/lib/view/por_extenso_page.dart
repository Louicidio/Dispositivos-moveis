import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class PorExtensoPage extends StatefulWidget {
  const PorExtensoPage({super.key});

  @override
  State<PorExtensoPage> createState() => _PorExtensoPageState();
}

class _PorExtensoPageState extends State<PorExtensoPage> {
  String? campo;
  String? moeda = 'BRL'; 
  String? resultado;
  final apiService = InvertextoService();

 
  final List<String> moedas = ['BRL', 'USD', 'EUR', 'GBP'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            // Campo de entrada para o número
            TextField(
              decoration: InputDecoration(
                labelText: "Digite um número",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),

            // Dropdown para selecionar a moeda
            DropdownButton<String>(
              value: moeda,
              onChanged: (String? newValue) {
                setState(() {
                  moeda = newValue!;
                });
              },
              items: moedas.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    _moedaFormatada(value),
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),

            Expanded(
              child: FutureBuilder(
                future: apiService.ConvertePorExtensao(campo, moeda),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.none) {
                    return Container(
                      width: 500,
                      height: 500,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        strokeWidth: 5.0,
                      ),
                    );
                  }

                  // Caso haja um erro
                  if (snapshot.hasError) {
                    return Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Ocorreu um erro: ${snapshot.error}",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        softWrap: true,
                      ),
                    );
                  }

                  // Caso não haja erro e o snapshot tenha dados válidos
                  if (snapshot.hasData) {
                    return exibeResultado(context, snapshot);
                  }

                  // Se o snapshot não tem dados e não há erro
                  return Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Nenhum dado encontrado.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para formatar a moeda
  String _moedaFormatada(String moeda) {
    switch (moeda) {
      case 'BRL':
        return 'Real (BRL)';
      case 'USD':
        return 'Dólar (USD)';
      case 'EUR':
        return 'Euro (EUR)';
      case 'GBP':
        return 'Libra Esterlina (GBP)';
      default:
        return moeda;
    }
  }

  // Função que exibe o resultado retornado pela API
  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        snapshot.data["text"] ?? '',
        style: TextStyle(color: Colors.white, fontSize: 18),
        softWrap: true,
      ),
    );
  }
}
