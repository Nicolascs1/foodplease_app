import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Productos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Map<String, dynamic>> _products = [];
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  void _addProduct() {
    final String name = _nameController.text;
    final double? price = double.tryParse(_priceController.text);

    if (name.isNotEmpty && price != null) {
      setState(() {
        _products.add({'name': name, 'price': price});
      });

      _nameController.clear();
      _priceController.clear();
    }
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _viewCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          products: _products,
          onDelete: _deleteProduct,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow.withOpacity(0.5),  // Fondo amarillo con 50% de transparencia
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centrar verticalmente
            crossAxisAlignment: CrossAxisAlignment.center, // Centrar horizontalmente
            children: <Widget>[
              Text(
                'FOODPLEASE',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.orange,  // Texto en color naranja
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Nombre'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _priceController,
                        decoration: InputDecoration(labelText: 'Precio'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _addProduct,
                      child: Text('Agregar'),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _viewCart,
                child: Text('Ver Carrito'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function(int) onDelete;

  CartScreen({required this.products, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index]['name']),
            subtitle: Text('Precio: \$${products[index]['price']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                onDelete(index);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      products: products,
                      onDelete: onDelete,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
