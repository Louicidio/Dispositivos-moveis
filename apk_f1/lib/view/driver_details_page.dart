import 'package:flutter/material.dart';

class DriverDetailsPage extends StatelessWidget {
  final Map<String, dynamic> driver;

  const DriverDetailsPage({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    String teamColor = driver['team_colour'] ?? 'FF0000';
    Color color = Color(int.parse('FF$teamColor', radix: 16));

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text(
          driver['full_name'] ?? 'Detalhes do Piloto',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.3), Colors.grey[900]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  if (driver['headshot_url'] != null)
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 4),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          driver['headshot_url'],
                          width: 142,
                          height: 142,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return CircleAvatar(
                              radius: 71,
                              backgroundColor: color,
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 71,
                        backgroundColor: color,
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    driver['full_name'] ?? 'Desconhecido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      driver['name_acronym'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.tag,
                    title: 'Número do Piloto',
                    value: driver['driver_number']?.toString() ?? 'N/A',
                    color: color,
                  ),
                  _buildInfoCard(
                    icon: Icons.person,
                    title: 'Nome Completo',
                    value: driver['full_name'] ?? 'N/A',
                    color: color,
                  ),
                  _buildInfoCard(
                    icon: Icons.badge,
                    title: 'Nome de Transmissão',
                    value: driver['broadcast_name'] ?? 'N/A',
                    color: color,
                  ),
                  _buildInfoCard(
                    icon: Icons.account_box,
                    title: 'Primeiro Nome',
                    value: driver['first_name'] ?? 'N/A',
                    color: color,
                  ),
                  _buildInfoCard(
                    icon: Icons.account_box,
                    title: 'Sobrenome',
                    value: driver['last_name'] ?? 'N/A',
                    color: color,
                  ),
                  _buildInfoCard(
                    icon: Icons.directions_car,
                    title: 'Equipe',
                    value: driver['team_name'] ?? 'N/A',
                    color: color,
                  ),
                  _buildInfoCard(
                    icon: Icons.palette,
                    title: 'Cor da Equipe',
                    value: '#${driver['team_colour'] ?? 'N/A'}',
                    color: color,
                    showColorPreview: true,
                  ),
                  _buildInfoCard(
                    icon: Icons.schedule,
                    title: 'Session Key',
                    value: driver['session_key']?.toString() ?? 'N/A',
                    color: color,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool showColorPreview = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (showColorPreview)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
