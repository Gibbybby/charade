class Category {
  final String id;
  final String nameKey;

  const Category({
    required this.id,
    required this.nameKey,
  });
}

const List<Category> categories = [
  Category(id: 'all', nameKey: 'category_all'),
  Category(id: 'kids', nameKey: 'category_kids'),
  Category(id: 'party', nameKey: 'category_party'),
  Category(id: 'films', nameKey: 'category_films'),
];
