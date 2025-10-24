import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // compute
import 'package:http/http.dart' as http;

// -------------------- MODEL --------------------
class Seller {
  final String name;
  final double rating;

  const Seller({required this.name, required this.rating});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'rating': rating,
      };
}

class Product {
  final int id;
  final String title;
  final double price;
  final bool inStock;
  final List<String> tags;
  final Seller seller;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.inStock,
    required this.tags,
    required this.seller,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      inStock: json['inStock'] as bool,
      tags: (json['tags'] as List).map((e) => e as String).toList(),
      seller: Seller.fromJson(json['seller']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'inStock': inStock,
        'tags': tags,
        'seller': seller.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };
}

// -------------------- PARSER --------------------
List<Product> parseProducts(String body) {
  final list = jsonDecode(body) as List<dynamic>;
  return list.map((e) => Product.fromJson(e)).toList();
}

Future<List<Product>> fetchProducts() async {
  final uri = Uri.parse("https://mocki.io/v1/0f456f56-67a1-42e5-b4cb-2740c3d7fa19");
  final res = await http.get(uri);

  if (res.statusCode == 200) {
    // Background isolate
    return compute(parseProducts, res.body);
  } else {
    throw Exception("Failed to load products: ${res.statusCode}");
  }
}

// -------------------- APP --------------------


class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return ListTile(
                  title: Text(p.title),
                  subtitle: Text("₹${p.price} • Seller: ${p.seller.name}"),
                  trailing: p.inStock
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.close, color: Colors.red),
                );
              },
            );
          } else {
            return const Center(child: Text("No products found"));
          }
        },
      ),
    );
  }
}
