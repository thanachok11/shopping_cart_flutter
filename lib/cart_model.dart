import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  double get totalPrice => _items.fold(
        0,
        (sum, item) =>
            sum + ((item['price'] as double) * (item['quantity'] as int)),
      );

  /// เพิ่มสินค้าหรืออัพเดทจำนวนในตะกร้า
  void addItem(Map<String, dynamic> product) {
    final existingIndex =
        _items.indexWhere((item) => item['name'] == product['name']);

    if (existingIndex >= 0) {
      // อัพเดทจำนวนสินค้า
      _items[existingIndex]['quantity'] += product['quantity'];
    } else {
      // เพิ่มสินค้าใหม่
      _items.add(product);
    }
    notifyListeners();
  }

  /// ลบสินค้าออกจากตะกร้า
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  /// อัพเดทจำนวนสินค้าในตะกร้า
  void updateQuantity(String productName, int quantity) {
    final index = _items.indexWhere((item) => item['name'] == productName);
    if (index >= 0) {
      _items[index]['quantity'] = quantity;
      if (_items[index]['quantity'] <= 0) {
        // ลบสินค้าออกหากจำนวนเหลือ 0
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// ลบสินค้าทั้งหมดในตะกร้า
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
