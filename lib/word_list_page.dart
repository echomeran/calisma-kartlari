import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ingilizce_calisma_kartlari/models.dart';
import 'package:ingilizce_calisma_kartlari/main.dart';
import 'package:ingilizce_calisma_kartlari/edit_word_page.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({super.key});

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  final _searchController = TextEditingController();
  String _searchText = "";
  
  void _deleteWord(WordCard word) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kelimeyi Sil'),
          content: Text('${word.englishWord} kelimesini silmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hayır', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Evet', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  word.delete(); 
                });
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleKnownStatus(WordCard word) {
    setState(() {
      word.isKnown = !word.isKnown;
      word.save(); 
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Kelime Listesi'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Kelime ara...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                filled: true,
                fillColor: const Color.fromARGB(255, 19, 19, 124),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const AppBackground(),
          ValueListenableBuilder(
            valueListenable: Hive.box<WordCard>('wordBox').listenable(),
            builder: (context, Box<WordCard> box, _) {
              final allWords = box.values.toList();
              if (allWords.isEmpty) {
                return const Center(
                  child: Text(
                    'Henüz hiç kelime eklenmemiş.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final filteredWords = allWords.where((word) {
                final query = _searchText.toLowerCase();
                return word.englishWord.toLowerCase().contains(query) ||
                    word.turkishWord.toLowerCase().contains(query);
              }).toList();

              if (filteredWords.isEmpty) {
                return const Center(
                  child: Text('Aradığınız kelime bulunamadı.', style: TextStyle(color: Colors.white)),
                );
              }

              return ListView.builder(
                itemCount: filteredWords.length,
                itemBuilder: (context, index) {
                  final word = filteredWords[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        word.englishWord,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      ),
                      subtitle: Text(word.turkishWord, style: const TextStyle(color: Colors.white),),
                       trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditWordPage(wordToEdit: word),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              word.isKnown ? Icons.check_circle : Icons.cancel,
                              color: word.isKnown ? Theme.of(context).colorScheme.primary : Colors.red,
                            ),
                            onPressed: () {
                              _toggleKnownStatus(word);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteWord(word);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}