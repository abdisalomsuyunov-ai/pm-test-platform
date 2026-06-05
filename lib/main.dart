import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: Dashboard()),
);

// --- REAL SAVOLLAR BAZASI (Mantiqiy-Matematik) ---
final Map<String, List<Map<String, dynamic>>> dataBank = {
  "Matematika": [
    {
      "q": "Agar 3 ta qalam 9000 so'm bo'lsa, 7 ta qalam necha so'm?",
      "o": ["21000", "18000", "24000", "15000"],
      "a": 0,
    },
    {
      "q":
          "Bir sonning yarmi 25 bo'lsa, o'sha sonning 2 baravari nechaga teng?",
      "o": ["50", "100", "75", "25"],
      "a": 1,
    },
  ],
  "Ingliz tili": [
    {
      "q": "Which sentence is correct?",
      "o": [
        "She don't like apple",
        "She doesn't like apples",
        "She no like apples",
        "She not like apples",
      ],
      "a": 1,
    },
    {
      "q": "Find the odd one out: Apple, Banana, Carrot, Orange",
      "o": ["Apple", "Banana", "Carrot", "Orange"],
      "a": 2,
    },
  ],
  "Mantiq": [
    {
      "q":
          "Tungi soat 12 da yomg'ir yog'ayotgan bo'lsa, 72 soatdan keyin quyosh chiqishi ehtimoli qancha?",
      "o": ["0%", "50%", "100%", "No'malum"],
      "a": 0,
    },
    {
      "q":
          "Kimning otasi 5 ta farzandi bor: Chacha, Cheche, Chichi, Chocho. Beshinchisi kim?",
      "o": ["Chuchu", "Dada", "Kim", "Siz"],
      "a": 0,
    },
  ],
};

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text("PM Imtihon Platformasi"),
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: dataBank.keys
            .map(
              (name) => Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blueAccent,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TestPage(subject: name)),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  final String subject;
  const TestPage({super.key, required this.subject});
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int idx = 0, score = 0, time = 60;
  late List<Map<String, dynamic>> questions;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    questions = List.from(dataBank[widget.subject]!)..shuffle();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (time > 0)
        setState(() => time--);
      else
        finish();
    });
  }

  void finish() {
    timer?.cancel();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Natija"),
        content: Text("To'g'ri javoblar: $score/${questions.length}"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yopish"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var q = questions[idx];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.subject} - ${idx + 1}/${questions.length}"),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (idx + 1) / questions.length,
            backgroundColor: Colors.grey[200],
            color: Colors.blueAccent,
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              q['q'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          ...List.generate(
            4,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: InkWell(
                onTap: () {
                  if (i == q['a']) score++;
                  if (idx < questions.length - 1)
                    setState(() => idx++);
                  else
                    finish();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Center(
                    child: Text(
                      q['o'][i],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
