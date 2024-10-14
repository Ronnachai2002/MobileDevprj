import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class Shopping extends StatefulWidget {
  const Shopping({super.key});

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // เรียกฟังก์ชันเพื่อดึงข้อมูลสินค้าเมื่อเปิดหน้า
  }

  Future<void> _fetchProducts() async {
    try {
      final url = 'https://fakestoreapi.com/products?limit=5';
      final response = await Requests.get(url);
      if (response.statusCode == 200) {
        setState(() {
          products = response.json();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch products: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UQuiz Shopping"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // แสดง loading หากยังโหลดไม่เสร็จ
          : ListView.separated(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return ListTile(
                  leading: Image.network(
                    product['image'],
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product['title']),
                  subtitle: Text('\$${product['price']}'),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(); // เส้นแบ่งระหว่างรายการสินค้า
              },
            ),
    );
  }
}
