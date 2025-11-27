import 'package:flutter/material.dart';
import 'package:apk_invertexto/service/invertexto_service.dart';


class VerificaCpfPage extends StatefulWidget {
  const VerificaCpfPage({super.key});

  @override
  State<VerificaCpfPage> createState() => _VerificaCpfPageState();
}

class _VerificaCpfPageState extends State<VerificaCpfPage> {
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
                labelText: "Digite um CPF",
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
                future: apiService.verificaCpf(campo),
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

                  if (snapshot.hasError) {
                    return Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Ocorreu um erro: [${snapshot.error}",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        softWrap: true,
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    return exibeResultado(context, snapshot);
                  }

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
    bool cpfValido = false;
    String? cpfFormatado;

    if (snapshot.data != null) {
      cpfValido = snapshot.data["valid"] ?? false;
      cpfFormatado = snapshot.data["cpf"];
    }

    String cpfValidoStr = cpfValido ? "CPF válido!" : "CPF inválido!";
    String cpfFormatadoStr = cpfFormatado != null ? "CPF formatado: $cpfFormatado" : "";

    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Text(
            cpfValidoStr,
            style: TextStyle(color: Colors.white, fontSize: 18),
            softWrap: true,
          ),
          if (cpfFormatadoStr.isNotEmpty)
            Text(
              cpfFormatadoStr,
              style: TextStyle(color: Colors.white, fontSize: 18),
              softWrap: true,
            ),
        ],
      ),
    );
  }
}
