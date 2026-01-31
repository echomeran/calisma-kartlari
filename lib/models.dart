import 'package:hive/hive.dart';

part 'models.g.dart'; 

@HiveType(typeId: 0)
class WordCard extends HiveObject {
  @HiveField(0)
  late String englishWord;

  @HiveField(1)
  late String turkishWord;

  @HiveField(2)
  late bool isKnown;
}