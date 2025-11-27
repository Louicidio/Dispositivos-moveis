import 'package:apk_formula1/service/openf1_service.dart';
import 'package:apk_formula1/view/driver_details_page.dart';
import 'package:apk_formula1/view/sessions_details_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String _search = "";
  bool _isLoadingDrivers = false;
  bool _isLoadingSessions = false;
  List<dynamic> _drivers = [];
  List<dynamic> _sessions = [];
  final OpenF1Service _f1Service = OpenF1Service();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDrivers();
    _loadSessions();
  }

  void _loadDrivers() async {
    setState(() {
      _isLoadingDrivers = true;
    });

    var drivers = await _f1Service.searchDrivers(_search);

    setState(() {
      _isLoadingDrivers = false;
      _drivers = drivers;
    });
  }

  void _loadSessions() async {
    setState(() {
      _isLoadingSessions = true;
    });

    var sessions = await _f1Service.getSessions();
    var sessions2025 = sessions.where((s) => s['year'] == 2025).toList();
    setState(() {
      _isLoadingSessions = false;
      _sessions = sessions2025;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_motorsports, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "F1",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: "Pilotos"),
            Tab(text: "Sessões"),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: TabBarView(
        controller: _tabController,
        children: [_buildDriversTab(), _buildSessionsTab()],
      ),
    );
  }

  Widget _buildDriversTab() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Buscar piloto",
              hintStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red[700]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red[500]!, width: 2),
              ),
            ),
            style: TextStyle(color: Colors.white, fontSize: 16),
            onChanged: (value) {
              setState(() {
                _search = value;
              });
              _loadDrivers();
            },
          ),
        ),
        Expanded(
          child: _isLoadingDrivers
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]!),
                    strokeWidth: 4.0,
                  ),
                )
              : _drivers.isEmpty
              ? Center(
                  child: Text(
                    "Nenhum piloto encontrado",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _drivers.length,
                  itemBuilder: (context, index) {
                    return _buildDriverCard(_drivers[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSessionsTab() {
    return _isLoadingSessions
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]!),
              strokeWidth: 4.0,
            ),
          )
        : _sessions.isEmpty
        ? Center(
            child: Text(
              "Nenhuma sessão encontrada",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _sessions.length,
            itemBuilder: (context, index) {
              final session = _sessions[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                color: Colors.grey[850],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red[700]!, width: 2),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    session['session_name'] ?? 'Sessão desconhecida',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    session['meeting_key']?.toString() ?? '',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    session['date_start']?.toString().substring(0, 10) ?? '',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SessionsDetailsPage(session: session),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver) {
    String teamColor = driver['team_colour'] ?? 'FF0000';
    Color color = Color(int.parse('FF$teamColor', radix: 16));

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color,
          radius: 28,
          child: Text(
            driver['driver_number']?.toString() ?? '?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          driver['full_name'] ?? 'Desconhecido',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.flag, color: Colors.white70, size: 16),
                SizedBox(width: 4),
                Text(
                  driver['country_code'] ?? '',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(width: 16),
                Text(
                  driver['name_acronym'] ?? '',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              driver['team_name'] ?? 'Time desconhecido',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.white70),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DriverDetailsPage(driver: driver),
            ),
          );
        },
      ),
    );
  }
}
