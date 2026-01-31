import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ingilizce_calisma_kartlari/models.dart';
import 'package:ingilizce_calisma_kartlari/main.dart';

class AddWordPage extends StatefulWidget {
  const AddWordPage({super.key});

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final _englishController = TextEditingController();
  final _turkishController = TextEditingController();

  void _saveWord() async {
    if (_englishController.text.isEmpty || _turkishController.text.isEmpty) {
      return;
    }

    var box = await Hive.openBox<WordCard>('wordBox');
    final newWord = WordCard()
      ..englishWord = _englishController.text
      ..turkishWord = _turkishController.text
      ..isKnown = false;
    await box.add(newWord);
    print('Kaydedilen Kelime: ${newWord.englishWord}');
    _englishController.clear();
    _turkishController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kelime başarıyla eklendi!', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Yeni Kelime Ekle'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15), // Ekran yüksekliğinin %15'i kadar aşağıda
              child: const AppBackground(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _englishController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'İngilizce Kelime',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _turkishController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Türkçe Kelime',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveWord,
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  }