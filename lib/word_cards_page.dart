import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ingilizce_calisma_kartlari/models.dart';
import 'dart:math';
import 'package:ingilizce_calisma_kartlari/main.dart';

class WordCardsPage extends StatefulWidget {
  const WordCardsPage({super.key});

  @override
  State<WordCardsPage> createState() => _WordCardsPageState();
}

class _WordCardsPageState extends State<WordCardsPage> {
  late Box<WordCard> _wordBox;
  WordCard? _currentCard;
  
  // KART DÖNÜŞ AÇISI: Başlangıçta 0.
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    _wordBox = Hive.box<WordCard>('wordBox');
    _loadNextWord();
  }

  void _loadNextWord() {
    final allWords = _wordBox.values.toList();
    if (allWords.isEmpty) {
      setState(() {
        _currentCard = null;
      });
      return;
    }

    final List<WordCard> weightedWords = [];
    for (var word in allWords) {
      if (word.isKnown) {
        weightedWords.add(word);
      } else {
        for (int i = 0; i < 20; i++) {
          weightedWords.add(word);
        }
      }
    }

    final random = Random();
    final nextWord = weightedWords[random.nextInt(weightedWords.length)];

    setState(() {
      _currentCard = nextWord;
      // YENİ KELİME GELDİĞİNDE: Açıyı sıfırla ki kart ön yüzüyle başlasın.
      _angle = 0; 
    });
  }

  void _updateWordStatus(bool isKnownStatus) {
    if (_currentCard != null) {
      _currentCard!.isKnown = isKnownStatus;
      _currentCard!.save();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Kelime Kartları'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const AppBackground(),
            Padding(
              padding: const EdgeInsets.only(top: 225.0),
              child: Center(
                child: _currentCard == null
                    ? const Text(
                        'Hiç kelime yok! Lütfen yeni kelime ekleyin.',
                        style: TextStyle(color: Colors.white),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Dismissible(
                            // ÖNEMLİ: UniqueKey yerine kartın kendi bilgisini veriyoruz.
                            // Böylece tıklandığında Flutter widget'ı silip baştan yaratmıyor.
                            key: ValueKey(_currentCard!.englishWord),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              _loadNextWord();
                            },
                            child: TweenAnimationBuilder<double>(
                              // Sadece end değerini veriyoruz, begin otomatik yönetiliyor.
                              tween: Tween<double>(end: _angle),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOutBack,
                              builder: (context, double value, child) {
                                // Arka yüz mü ön yüz mü hesaplaması
                                final double normalizedAngle = value % 360;
                                final bool isBack = normalizedAngle >= 90 && normalizedAngle <= 270;

                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001) // Derinlik
                                    ..rotateY(value * (pi / 180)), // Derece -> Radyan
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Her tıklandığında 180 derece ileri döner.
                                        _angle += 180;
                                      });
                                    },
                                    child: isBack
                                        ? _buildCardSide(
                                            context,
                                            _currentCard!.turkishWord,
                                            true,
                                          )
                                        : _buildCardSide(
                                            context,
                                            _currentCard!.englishWord,
                                            false,
                                          ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => _updateWordStatus(true),
                                child: const Text('Biliyorum'),
                              ),
                              ElevatedButton(
                                onPressed: () => _updateWordStatus(false),
                                child: const Text('Bilmiyorum'),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSide(BuildContext context, String text, bool isBack) {
    return Transform(
      alignment: Alignment.center,
      // İçerideki metnin ters görünmemesi için arka yüzde içeriği de 180 derece çeviriyoruz.
      transform: isBack ? Matrix4.rotationY(pi) : Matrix4.identity(),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color.fromARGB(255, 19, 19, 124),
        child: Container(
          width: 300,
          height: 200,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF40C4FF),
                    ),
              ),
              const SizedBox(height: 10),
              Icon(
                _currentCard!.isKnown ? Icons.check_circle : Icons.cancel,
                color: _currentCard!.isKnown ? const Color(0xFF40C4FF) : Colors.red,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}