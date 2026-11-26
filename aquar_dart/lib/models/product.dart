class Product {
  final String id;
  final String name;
  final String size;
  final double price;
  final String description;
  final bool available;
  final String? image;

  const Product({
    required this.id,
    required this.name,
    required this.size,
    required this.price,
    required this.description,
    this.available = true,
    this.image,
  });
}
