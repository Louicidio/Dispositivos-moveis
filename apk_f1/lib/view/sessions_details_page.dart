import 'package:flutter/material.dart';

class SessionsDetailsPage extends StatelessWidget {
  final Map<String, dynamic> session;

  const SessionsDetailsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Sessão', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[700],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 400,
          child: Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.red[700]!, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Nome: ${session['session_name'] ?? '-'}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Meeting Key: ${session['meeting_key'] ?? '-'}",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Data de início: ${session['date_start']?.toString().substring(0, 10) ?? '-'}",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Data de fim: ${session['date_end']?.toString().substring(0, 10) ?? '-'}",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Local: ${session['location'] ?? '-'}",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "País: ${session['country_name'] ?? '-'}",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Circuito: ${session['circuit_short_name'] ?? '-'}",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Ano: ${session['year']?.toString() ?? '-'}",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Tipo de sessão: ${session['session_type'] ?? '-'}",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
