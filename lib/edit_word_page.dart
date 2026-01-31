// edit_word_page.dart dosyasının içeriği
import 'package:flutter/material.dart';
import 'package:ingilizce_calisma_kartlari/models.dart';
import 'package:ingilizce_calisma_kartlari/main.dart'; // Arka plan widget'ı için import ediyoruz

class EditWordPage extends StatefulWidget {
  final WordCard wordToEdit;

  const EditWordPage({super.key, required this.wordToEdit});

  @override
  State<EditWordPage> createState() => _EditWordPageState();
}

class _EditWordPageState extends State<EditWordPage> {
  late TextEditingController _englishController;
  late TextEditingController _turkishController;

  @override
  void initState() {
    super.initState();
    // Mevcut kelimeleri controller'lara yüklüyoruz
    _englishController = TextEditingController(text: widget.wordToEdit.englishWord);
    _turkishController = TextEditingController(text: widget.wordToEdit.turkishWord);
  }

  void _updateWord() {
    if (_englishController.text.isEmpty || _turkishController.text.isEmpty) {
      // Kelime alanları boşsa uyarı ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen kelime alanlarını boş bırakmayın.')),
      );
      return;
    }

    // Kelimenin özelliklerini güncelle
    widget.wordToEdit.englishWord = _englishController.text;
    widget.wordToEdit.turkishWord = _turkishController.text;

    // Hive'daki veriyi güncellemek için save() metodunu kullan
    widget.wordToEdit.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kelime başarıyla güncellendi!'),
        backgroundColor: Colors.green,
      ),
    );

    // Bir önceki sayfaya geri dön
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelimeyi Düzenle'),
      ),
      body: Stack(
        children: [
          const AppBackground(),
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
                  onPressed: _updateWord,
                  child: const Text('Güncelle'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}