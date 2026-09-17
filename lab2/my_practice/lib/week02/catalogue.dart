import 'models.dart';

class Library {
  final List<LibraryItem> items = [];
  late final DateTime openedAt;
  String? _cachedReport;

  void open() {
    openedAt = DateTime.now();
  }

  void add(LibraryItem item) {
    items.add(item);
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }

  String countryOf(String title) {
    return findByTitle(title)?.author.country ?? 'unknown';
  }

  String buildReport() {
    final report = _cachedReport;
    if (report != null) return report;
    final newReport = 'Library opened at $openedAt with ${items.length} items.';
    _cachedReport = newReport;
    return newReport;
  }

  Iterable<String> get allTitles => items.map((item) => item.title);

  Iterable<Book> get booksAfter2010 =>
      items.whereType<Book>().where((book) => book.year > 2010);

  double get averagePages {
    final books = items.whereType<Book>();
    if (books.isEmpty) return 0.0;
    final total = books.fold<int>(0, (sum, book) => sum + book.pages);
    return total / books.length;
  }

  Map<String, int> get bookCountByAuthor {
    final books = items.whereType<Book>();
    return books.fold<Map<String, int>>({}, (map, book) {
      map[book.author.name] = (map[book.author.name] ?? 0) + 1;
      return map;
    });
  }

  Set<String> get uniqueAuthors =>
      items.whereType<Book>().map((b) => b.author.name).toSet();

  Set<Genre> get presentGenres =>
      items.whereType<Book>().map((b) => b.genre).toSet();

  List<String> get displayList {
    final books = items.whereType<Book>().toList();
    final hasIncompleteData = books.any((b) => b.pages == 0);

    return [
      'CATALOGUE',
      for (final book in books) '${book.title} (${book.year})',
      ...uniqueAuthors,
      if (hasIncompleteData) '(incomplete data)',
    ];
  }
}
