import 'package:flutter/material.dart';
import 'package:apk_invertexto/service/invertexto_service.dart';


class VerificaEmailPage extends StatefulWidget {
  const VerificaEmailPage({super.key});

  @override
  State<VerificaEmailPage> createState() => _VerificaEmailPageState();
}

class _VerificaEmailPageState extends State<VerificaEmailPage> {
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
              labelText: "Digite um Email",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontSize: 18),
            onSubmitted: (value) {
              setState(() {
                campo = value;
              });
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: apiService.verificaEmail(campo),
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
  bool emailTemporario = true;
  bool emailValido = true;
  bool validMX = false;

  if (snapshot.data != null) {
    emailValido = snapshot.data["valid_format"];
    emailTemporario = snapshot.data["disposable"];
    validMX = snapshot.data["valid_mx"];
  }

  String emailValidoStr = emailValido ? "Email válido!" : "Email inválido!";
  String emailTemporarioStr = emailTemporario ? "Email temporário!" : "Email permanente!";
  String validMXStr = validMX ? "Domínio com registro MX válido!" : "Domínio sem registro MX válido!";

  return Padding(
    padding: EdgeInsets.only(top: 10.0),
    child: Column(
      children: [
        Text(
          emailValidoStr,
          style: TextStyle(color: Colors.white, fontSize: 18),
          softWrap: true,
        ),
        Text(
          emailTemporarioStr,
          style: TextStyle(color: Colors.white, fontSize: 18),
          softWrap: true,
        ),
        Text(
          validMXStr,
          style: TextStyle(color: Colors.white, fontSize: 18),
          softWrap: true,
        ),
      ],
    ),
  );
}
}