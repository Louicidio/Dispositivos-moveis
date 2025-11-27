import 'dart:convert';
import 'package:http/http.dart' as http;
// implementar resultados da sessão (resposta da API no beta, talvez não funcione)
class OpenF1Service {
  static const String _baseUrl = "https://api.openf1.org/v1";

  Future<List<dynamic>> searchDrivers(String search) async {
    try {
      http.Response response;

      response = await http.get(
        Uri.parse("$_baseUrl/drivers?session_key=latest"),
      );

      if (response.statusCode == 200) {
        List<dynamic> allDrivers = json.decode(response.body);

        if (search.isEmpty) {
          return allDrivers;
        }

        return allDrivers.where((driver) {
          String searchLower = search.toLowerCase();
          String fullName = driver['full_name']?.toString().toLowerCase() ?? '';
          String firstName =
              driver['first_name']?.toString().toLowerCase() ?? '';
          String lastName = driver['last_name']?.toString().toLowerCase() ?? '';
          String driverNumber = driver['driver_number']?.toString() ?? '';
          String teamName = driver['team_name']?.toString().toLowerCase() ?? '';

          return fullName.contains(searchLower) ||
              firstName.contains(searchLower) ||
              lastName.contains(searchLower) ||
              driverNumber.contains(searchLower) ||
              teamName.contains(searchLower);
        }).toList();
      }

      return [];
    } catch (e) {
      print("Erro ao buscar pilotos: $e");
      return [];
    }
  }
  Future<List<dynamic>> getSessions() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/sessions"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      print("Erro ao buscar sessões: $e");
      return [];
    }
  }
}
