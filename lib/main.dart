import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'cart_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Cart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'iPhone 15',
      'price': 1299.0,
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-15-finish-select-202309-6-1inch-blue?wid=5120&hei=2880&fmt=webp&qlt=70&.v=cHJOTXEwTU92OEtKVDV2cVB1R2FTSjlERndlRTljaUdZeHJGM3dlLzR2OGlYQ0tYMHd1OS9ZREtnNzFSR1owOHF2TWlpSzUzejRCZGt2SjJUNGl1VEtsS0dZaHBma3VTb3UwU2F6dkc4TGZPaDVjV2NEQVBZbTZldUQyWkpKRHk&traceId=1',
    },
    {
      'name': 'MacBook Pro',
      'price': 2499.0,
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mbp14-spaceblack-select-202410?wid=904&hei=840&fmt=jpeg&qlt=90&.v=1728916305295',
    },
    {
      'name': 'iPad Air',
      'price': 799.0,
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/ipad-air-model-unselect-gallery-1-202405?wid=5120&hei=2880&fmt=webp&qlt=70&.v=azZtTlRzREZ3NzhWaHRDQW5YeUV0UEs0TkxxOFYxN2dtSHJMdW5sNDFVK3MxV2hYTmJkSS9ZdDBsUEkxd0lnTE9UVDVQbVhkcDIxQlRzeDZXVVpQSzkyUzNxNUJkYUtvMmZUbWtpbCtIZFA4VWEyeVNLWWN4VjljeXFFSFhCanU&traceId=1',
    },
    {
      'name': 'AirPods Pro',
      'price': 249.0,
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/airpods-pro-2-202409-gallery-4?wid=4056&hei=2400&fmt=jpeg&qlt=90&.v=1726015508374',
    },
  ];

  final Map<int, int> quantities = {}; // Stores quantities for each product.

  // ฟังก์ชันในการรีเซ็ตค่าปริมาณสินค้าทุกตัวเป็น 1
  void resetQuantities() {
    setState(() {
      quantities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              Consumer<CartModel>(
                builder: (context, cart, child) {
                  int totalQuantity = cart.items.fold<int>(
                    0,
                    (sum, item) => sum + (item['quantity'] as int? ?? 1),
                  );
                  return Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$totalQuantity',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ปุ่มเคลียร์ข้อมูลจำนวนสินค้าที่เลือก
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: resetQuantities,
                  icon: const Icon(Icons.close),
                  label: const Text('Clear quantities'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 228, 227, 227), // Red color for "X" button
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      product['imageUrl'], // Load the image from the URL
                      width: 50, // Set a specific width for the image
                      height: 50, // Set a specific height for the image
                      fit: BoxFit
                          .cover, // Make sure the image is properly fitted
                    ),
                    title: Text(product['name']),
                    subtitle: Text('\$${product['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantities[index] != null &&
                                  quantities[index]! > 0) {
                                quantities[index] = quantities[index]! - 1;
                              }
                            });
                          },
                        ),
                        Text(
                          quantities[index]?.toString() ?? '0',
                          style: const TextStyle(fontSize: 12),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantities[index] = (quantities[index] ?? 0) + 1;
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final selectedQuantity = quantities[index] ?? 1;
                            Provider.of<CartModel>(context, listen: false)
                                .addItem({
                              'name': product['name'],
                              'price': product['price'],
                              'quantity': selectedQuantity
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${product['name']} added to cart (x$selectedQuantity)'),
                              ),
                            );
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
