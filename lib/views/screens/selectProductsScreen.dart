import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../data/cocktails.dart';

class SelectProductsScreen extends StatefulWidget {
  const SelectProductsScreen({super.key});

  @override
  State<SelectProductsScreen> createState() => _SelectProductsScreenState();
}

class _SelectProductsScreenState extends State<SelectProductsScreen> {
  final List<Product> _selectedProducts = [];

  void _toggleProduct(Product product, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedProducts.add(product);
      } else {
        _selectedProducts.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar cocktails"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedProducts);
            },
            child: const Text(
              "CONFIRMAR", 
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),

      body: ListView.builder(
        itemCount: MockData.cocktails.length,
        itemBuilder: (context, index) {
          final product = MockData.cocktails[index];
          
          final isChecked = _selectedProducts.contains(product);

          return CheckboxListTile(
            title: Text(product.name),
            subtitle: Text("${product.price} €"),
            value: isChecked,
            activeColor: Colors.blueAccent,
            onChanged: (bool? value) {
              if (value != null) {
                _toggleProduct(product, value);
              }
            },
          );
        },
      ),
    );
  }
}