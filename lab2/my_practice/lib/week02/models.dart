class Author {
  final String name;
  final String? country;

  const Author({required this.name, this.country});

  @override
  String toString() => 'Author(name: $name, country: $country)';
}

enum Genre {
  craft('Software Craftsmanship'),
  theory('Computer Science Theory'),
  unknown('Unknown Genre');

  final String label;
  const Genre(this.label);

  static Genre fromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'craft':
        return Genre.craft;
      case 'theory':
        return Genre.theory;
      default:
        return Genre.unknown;
    }
  }
}

abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({required this.title, required this.year});

  String describe();

  bool get isOld => (DateTime.now().year - year) > 20;
}

mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Borrowed: $title';
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final authorName = json['author'] as String? ?? 'Unknown Author';
    final authorCountry = json['country'] as String?;

    return Book(
      title: json['title'] as String? ?? 'Untitled',
      year: json['year'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      author: Author(name: authorName, country: authorCountry),
      genre: Genre.fromString(json['genre'] as String?),
      description: json['description'] as String?,
    );
  }

  bool get isLong => pages > 400;

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String describe() =>
      'Book "$title" ($year), $pages pages, Genre: ${genre.label}';

  @override
  String toString() =>
      'Book(title: $title, year: $year, pages: $pages, author: ${author.name})';
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() => 'Magazine "$title" Issue #$issue ($year)';
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  Ghost({required this.title, required this.year});

  @override
  String describe() => 'Ghost item: $title ($year)';

  @override
  bool get isOld => (DateTime.now().year - year) > 20;
}
