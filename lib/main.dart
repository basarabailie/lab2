import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(FrizeriiApp());
}

// Model pentru Frizerie
class Frizerie {
  final String nume;
  final String distanta;
  final double rating;
  final String imagine;

  Frizerie({
    required this.nume,
    required this.distanta,
    required this.rating,
    required this.imagine,
  });

  // Funcție pentru a transforma datele JSON în obiecte Frizerie
  factory Frizerie.fromJson(Map<String, dynamic> json) {
    return Frizerie(
      nume: json['nume'],
      distanta: json['distanta'],
      rating: json['rating'].toDouble(),
      imagine: json['imagine'],

    );
  }
}

// Aplicația principală
class FrizeriiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frizerii App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: FrizeriiScreen(),
    );
  }
}

// Ecranul principal al aplicației
class FrizeriiScreen extends StatefulWidget {
  @override
  _FrizeriiScreenState createState() => _FrizeriiScreenState();
}

class _FrizeriiScreenState extends State<FrizeriiScreen> {
  List<Frizerie> frizeriiApropiate = [];
  List<Frizerie> frizeriiRecomandate = [];

  // Funcție pentru a încărca datele din JSON
  Future<void> loadFrizerii() async {
    final String response = await rootBundle.loadString('assets/frizerii.json');
    final data = await json.decode(response);

    setState(() {
      frizeriiApropiate = (data['frizeriiApropiate'] as List)
          .map((item) => Frizerie.fromJson(item))
          .toList();
      frizeriiRecomandate = (data['frizeriiRecomandate'] as List)
          .map((item) => Frizerie.fromJson(item))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadFrizerii();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("BARBERSHOP", style: TextStyle(fontWeight: FontWeight.bold)),
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Image.asset('assets/banner.png', height: 150, fit: BoxFit.cover),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              elevation: 0,
            ),
            child: Text(
              "Booking Now",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16.0),
          BaraCautare(),
          SizedBox(height: 24.0),
          SectiuneFrizerii(
            titlu: 'Nearest Barbershop',
            frizerii: frizeriiApropiate,
          ),
          SizedBox(height: 24.0),
          SectiuneFrizerii(
            titlu: 'Most Recommended',
            frizerii: frizeriiRecomandate,
          ),
        ],
      ),
    );
  }
}

// Widget pentru bara de căutare
class BaraCautare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        hintText: 'Search barber, haircut styles...',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// Widget pentru secțiunile de frizerii
class SectiuneFrizerii extends StatelessWidget {
  final String titlu;
  final List<Frizerie> frizerii;

  SectiuneFrizerii({required this.titlu, required this.frizerii});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titlu,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 260, // Înălțimea listei orizontale de frizerii
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: frizerii.length,
            itemBuilder: (context, index) {
              return FrizerieCard(frizerie: frizerii[index]);
            },
          ),
        ),
      ],
    );
  }
}

// Widget pentru fiecare card de frizerie
class FrizerieCard extends StatelessWidget {
  final Frizerie frizerie;

  FrizerieCard({required this.frizerie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Creșterea lățimii pentru o mai bună dispunere a conținutului
      height: 230, // Creșterea înălțimii totale a cardului
      margin: EdgeInsets.only(right: 12),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                frizerie.imagine,
                height: 100, // Creșterea înălțimii imaginii
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    frizerie.nume,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    frizerie.distanta,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        frizerie.rating.toString(),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Booking"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
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
