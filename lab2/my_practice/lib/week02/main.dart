import 'data.dart';
import 'models.dart';
import 'catalogue.dart';
import 'shelf_state.dart';

void main() {
  final library = Library()..open();

  for (final raw in rawBooks) {
    library.add(Book.fromJson(raw));
  }

  print('=== 1. All Titles ===');
  print(library.allTitles.toList());

  print('\n=== 2. Books After 2010 ===');
  for (final book in library.booksAfter2010) {
    print('${book.title} (${book.year})');
  }

  print('\n=== 3. Average Pages ===');
  print(library.averagePages.toStringAsFixed(1));

  print('\n=== 4. Book Count By Author ===');
  print(library.bookCountByAuthor);

  print('\n=== 5. Display List ===');
  for (final line in library.displayList) {
    print(line);
  }

  print('\n=== 6. Dart 3 Records & Stats ===');
  final booksOnly = library.items.whereType<Book>().toList();
  final stats = statsOf(booksOnly);
  print(
    'Total Books: ${stats.count}, Avg Pages: ${stats.avgPages.toStringAsFixed(1)}',
  );

  print('\n=== 7. Dart 3 Sealed Class & Patterns ===');
  print(describe(Empty()));
  print(describe(Ready(booksOnly)));
  print(describe(Broken('Shelf broken under heavy load')));

  print('\n=== 8. Null Safety Test ===');
  print('Country for "Clean Code": ${library.countryOf('Clean Code')}');
  print(
    'Country for "Design Patterns": ${library.countryOf('Design Patterns')}',
  );
  print('Country for "Unknown": ${library.countryOf('Non Existent')}');
}
