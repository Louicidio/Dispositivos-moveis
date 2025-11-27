import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class BuscaCepPage extends StatefulWidget {
  const BuscaCepPage({super.key});

  @override
  State<BuscaCepPage> createState() => _BuscaCepPageState();
}

class _BuscaCepPageState extends State<BuscaCepPage> {
  String? campo;
  String? resultado;
  final apiService = InvertextoService();

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
            TextField(
              decoration: InputDecoration(
                labelText: "Digite um CEP",
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
            Expanded(
              child: FutureBuilder(
                future: apiService.buscaCEP(campo),
                builder: (context, snapshot) {
                // Caso a conexão esteja esperando ou inexistente
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

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    String enderecoCompleto = '';
    if(snapshot.data != null){
      enderecoCompleto += snapshot.data["street"] ?? 'Rua não identificada';
      enderecoCompleto += "\n";
      enderecoCompleto += snapshot.data["neighborhood"] ?? 'Bairro não identificado';
      enderecoCompleto += "\n";
      enderecoCompleto += snapshot.data["city"] ?? 'Cidade não identificada';
      enderecoCompleto += "\n";
      enderecoCompleto += snapshot.data["state"] ?? 'Estado não identificado';
      enderecoCompleto += "\n";
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        enderecoCompleto,
        style: TextStyle(color: Colors.white, fontSize: 18,),
        softWrap: true,
      ),
    );
  }
}