// main.dart dosyasının tamamı
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ingilizce_calisma_kartlari/models.dart';
import 'package:ingilizce_calisma_kartlari/add_word_page.dart';
import 'package:ingilizce_calisma_kartlari/word_cards_page.dart';
import 'package:ingilizce_calisma_kartlari/word_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WordCardAdapter());
  await Hive.openBox<WordCard>('wordBox');
  runApp(const MyApp());
}

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF01131F), Color(0xFF0A0E21), Color(0xFF13137C)],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelime Kartları Uygulaması',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 1, 19, 31),
        primarySwatch: Colors.indigo,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF40C4FF),
          secondary: Colors.cyanAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Color(0xFF40C4FF),
        ),
        cardTheme: const CardThemeData(color: Color.fromARGB(255, 19, 19, 124)),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF40C4FF),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 22,
            ), 
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                15,
              ), 
            ),
            elevation: 5,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(), // Yeni gradyanlı arka planın burada olduğunu varsayıyorum
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Butonları yukarı, merkeze taşır
              children: <Widget>[
                // Logo alanı - Logonu burada daha zarif bir şekilde gösterebiliriz
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset('assets/logo.jpg', height: 120), // Logonun boyutu
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Butonlar
                _buildMenuButton(
                  context, 
                  'Kelime Ekle', 
                  Icons.add_circle_outline, 
                  const AddWordPage()
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context, 
                  'Kartlara Başla', 
                  Icons.play_lesson_outlined, 
                  const WordCardsPage()
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context, 
                  'Kelime Listesi', 
                  Icons.format_list_bulleted, 
                  const WordListPage()
                ),
                const SizedBox(height: 50), // En alt boşluğu azalttık
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Butonları daha düzenli oluşturmak için yardımcı bir fonksiyon
  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Widget page) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7, // Buton genişliği ekranın %70'i
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        icon: Icon(icon, size: 24),
        label: Text(title),
      ),
    );
  }
}
